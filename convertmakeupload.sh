#!/bin/bash

echo Enter the directory containing TIFF files
read tiffdir

echo What should I call the PDF (e.g: macworld_au-2007.09)
read pdfname

#rename tiff to tif because opj_compress doesn't like four character file extensions
for file in $tiffdir/*.tiff ; do mv $file `echo $file | sed 's/\(.*\.\)tiff/\1tif/'` ; done

#use imagemagick to remove alpha channel becuse opj_compress doesn't handle TIFFs with alpha channels
for file in $tiffdir/*.tif ; do convert $file -alpha off $file ; done

#convert all TIFF files to lossless JPEG2000 with the extension JP2
opj_compress -ImgDir $tiffdir -OutFor JP2

#move JP2 and TIFF files to their own directories
mkdir $tiffdir/jp2
mkdir $tiffdir/tif
mv $tiffdir/*.tif $tiffdir/tif
mv $tiffdir/*.JP2 $tiffdir/jp2

#make PDF of JPEG2000 files
img2pdf -v -o /videos/scans/pdfs/$pdfname.pdf *.JP2

#archive the original TIFF scans
tar -cjvf /videos/scans/archives/$pdfname.tar.bz2 $tiffdir/tif/*.tif
