#! /bin/bash
if [ $# -ne 1 -o "$1" = "--help" ]
then
echo "using validate.sh xmlfile"
exit 0
fi
export SP_CHARSET_FIXED=YES    
export SP_ENCODING=XML 
export SGML_CATALOG_FILES=/usr/share/doc/openjade-1.3/xml.soc
if [ ! -f $SGML_CATALOG_FILES ]
then 
 echo "Catalog file can't be found in $SGML_CATALOG_FILES please edit your script validate.sh"
 exit 1
fi
nsgmls -s -wxml -D `dirname $0`/dtd/ $1
