#!/bin/bash

echo "<html><head><title>Birds of Chandigarh, Punjab, and Haryana</title><link rel='stylesheet' type='text/css' href='guide.css'/></head><body>" > birds.html 
echo "<h3>Birds of Chandigarh, Punjab, and Haryana</h3>" >> birds.html
echo "<p>This guide was generated programatically from the data provided by this PDF <a href='http://www.pbforests.gov.in/Pdfs/wildlife/Punjabi%20names%20of%20birds%20of%20Punjab.pdf'>ENGLISH, PUNJABI AND SCIENTIFIC NAMES OF BIRDS OF PUNJAB</a> courtesy of <a href='http://www.pbforests.gov.in'>The Department of Forests & Wildlife Preservation, Punjab</a>.</p>" >> birds.html  
FILES=images/*.jpg
for f in $FILES
do
   echo "Processing $f file..."
   X=`echo $f |  sed -e "s/-/ /g" | sed -e "s/.jpg//g" | sed -e "s/images\///g"`
   echo "<div class='float'>" >> birds.html 
   echo "<a href='https://en.wikipedia.org/wiki/$X'><img src='$f' width='200' height='200' alt='$X' /></a><br/>" >> birds.html
   echo "<p><a href='https://en.wikipedia.org/wiki/$X'>$X</a></p>" >> birds.html
   echo "</div>" >> birds.html  
  
done
echo "</body></html>" >> birds.html

python /Users/ibrown/Documents/TwitterSummaryCardGenerator/src/python/TwitterSummaryCardGenerator.py -f ./birds.html -t igb -d ./

