-module(birds).
-export([get_photos/1]).

get_photos(File)->
    {ok, Device} = file:open(File,[read]),
    for_each_line(Device).
 
for_each_line(Device) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device);
        Line -> Name=string:strip(Line, right, $\n),io:fwrite("~p~n",[Name]),get_photo_from_flickr(Name),
                    for_each_line(Device)
    end.


get_photo_from_flickr(Name)->
 {_,_,_,_,IgbRefs}=flittr:search_user_photos("20721230@N00", "f01f8180ef7d445bacc1a95d0d9a7efd", Name, "1,2,4,5,6,8"),
 {_,_,_,_,Refs}=flittr:search_photos("", "f01f8180ef7d445bacc1a95d0d9a7efd", Name, "1,2,4,5,6,8"),
 download_photo(lists:append(IgbRefs,Refs), Name). 

download_photo([Ref|Remainder], Name)->
        Url=flittr:photo_source_url_from_photoref(Ref),
	Response=httpc:request(get, {Url, []}, [{autoredirect, false}], []),
 	case Response of 
	  {ok, {{Version, 200, "OK"}, Headers, Body}} -> io:fwrite("that url worked: ~p~n", [Url]), file:write_file(lists:append(["images/", re:replace(Name, " ", "-", [global, {return, list}]), ".jpg"]), Body),write_metadata(Ref, Name); 
	  _ -> io:fwrite("error downloading ~p~n",[Url]),download_photo(Remainder, Name)
	 end;	  
  

download_photo([], Name)->
   io:fwrite("could not download any images for ~p...moving on", [Name]).

write_metadata(PhotoRef, Name)->
 Attributes=flittr:get_photo_info(flittr:id_from_photoref(PhotoRef), "f01f8180ef7d445bacc1a95d0d9a7efd"),
 {license,License}=lists:keyfind(license, 1, Attributes),
 {LicenseDesc, LicenseUrl}=flittr:get_license(License), 
 Owner=flittr:owner_from_photoref(PhotoRef),
 Person=flittr:get_person("", "f01f8180ef7d445bacc1a95d0d9a7efd", Owner),
 {_,Metadata}=lists:keyfind(metadata, 1, Person),
 {_,Username}=lists:keyfind(username, 1, Metadata),
 {_,ProfileUrl}=lists:keyfind(profileurl, 1, Metadata),
 file:write_file(lists:append(["metadata/", re:replace(Name, " ", "-", [global, {return, list}]), "-metadata.txt"]), lists:flatten(["<span class='metadata'>Photo by <a href='", ProfileUrl, "'>",Username, "</a><br><a href='",LicenseUrl,"'>",LicenseDesc,"</a></span>\n<!-- ",flittr:id_from_photoref(PhotoRef)," -->\n"])),
 ok.