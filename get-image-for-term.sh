echo $1
term=`echo $1 | python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'`
url=`curl -s  "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&as_filetype=jpg&q=$term" | json_pp | grep unescapedUrl | head -1 | sed -E 's/.{30}//' | sed -E 's/.{2}$//'`
curl $url -o ./images/$term.jpg

