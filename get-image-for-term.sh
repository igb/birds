curl "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=$0" | json_pp | grep unescapedUrl | head -1 | sed -E 's/.{30}//' | sed -E 's/.{2}$//' 


