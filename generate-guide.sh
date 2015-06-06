#!/bin/bash

echo "<html><head><title>Birds of Chandigarh, Punjab, and Haryana</title><link rel='stylesheet' type='text/css' href='guide.css'/></head><body>" > birds.html 
echo "<h3>Birds of Chandigarh, Punjab, and Haryana</h3>" >> birds.html
echo "<p>This guide was generated programatically from the data provided by " >> birds.html 
echo " <a href='http://www.pbforests.gov.in'>The Department of Forests & Wildlife Preservation, Punjab</a>. The original list of names can be found in this PDF: <i><a href='http://www.pbforests.gov.in/Pdfs/wildlife/Punjabi%20names%20of%20birds%20of%20Punjab.pdf'>ENGLISH, PUNJABI AND SCIENTIFIC NAMES OF BIRDS OF PUNJAB</a></i>" >> birds.html
echo " Most of the images contained withing this page were downloaded via Google's image search API and therfore the copyright and usage is likely to be an issue. Wherever possible I have attempted to use images for which I own the rights. These images are licensed under the Creative Commons license X.</p>" >> birds.html  
FILES=images/*.jpg
for f in $FILES
do
   echo "Processing $f file..."
   X=`echo $f |  sed -e "s/-/ /g" | sed -e "s/.jpg//g" | sed -e "s/images\///g"`
   echo "<div class='float'>" >> birds.html 
   echo "<a class='reference' href='https://en.wikipedia.org/wiki/$X'><img src='$f' width='300' height='300' alt='$X' /></a><br/>" >> birds.html
   echo "<p><a class='reference' href='https://en.wikipedia.org/wiki/$X'><i>$X</i></a>" >> birds.html
   Y=`echo $f |  sed -e "s/.jpg/-metadata.txt/g" | sed -e "s/images/metadata/g"`
   echo "<br/>" >> birds.html
   echo $Y
   if [ -e "$Y" ]
   then
     cat $Y >>  birds.html
   else
	echo "<span class='metadata'>&nbsp;<br/>&nbsp;</span>" >>  birds.html
   fi
   echo "</p></div>" >> birds.html  
  
done
echo "</body></html>" >> birds.html

python /Users/ibrown/Documents/TwitterSummaryCardGenerator/src/python/TwitterSummaryCardGenerator.py -f ./birds.html -t igb -d ./

