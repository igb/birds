#!/bin/bash
FILES=images/*.jpg
for f in $FILES
do
   echo "Processing $f file..."
   X=`echo $f | sed -e "s/%20/-/g"`
   git mv $f $X
done


