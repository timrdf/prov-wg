#!/bin/bash
#3> <> prov:wasAttributedTo <http://tw.rpi.edu/instances/TimLebo>,
#3>                         <http://data.semanticweb.org/person/paul-groth>;
#3>    rdfs:seeAlso <readme.md> .
#
# This script follows ../prov.owl as a template to produce a releasable concatenation at ../releases/$version/prov.owl.
#
# This script will materialize any prov:hadDerivation that appears in prov.owl, 
# by fetching the OWL and Turtle versions that are hard-coded into this script (for Turtle) and in prov-ns.xsl (for RDF/XML).

   prev="prov-YYYYmmdd"
version="prov-YYYYMMDD"

if [ "$1" == "--help" ]; then
   echo "usage: `basename $0` [previous-version] [version]"
   echo
   echo "  previous-version e.g. prov-20121211 (default: $prev)"
   echo "           version e.g. prov-20130131 (default: $version)"
   exit
elif [ $# -eq 2 ]; then
   prev=$1
   version=$2
else
   echo
   echo "WARNING: using default version identifiers; see `basename $0` --help"
   echo
fi

HOME=$(cd ${0%/*} && echo ${PWD%/*})

release=$HOME/releases/$version/prov.owl
if [ ! -e `dirname $release` ]; then
   mkdir -p `dirname $release` 
fi

java -jar $HOME/lib/saxon9.jar $HOME/prov.owl $HOME/bin/prov-ns.xsl previous-version=$prev version=$version > $release

echo
release=${release##`pwd`/}
echo $release
#echo ${release}.ttl
#rapper -q -g -o turtle $release > ${release}.ttl

turtle=${release%.owl}.ttl
echo $turtle
echo "@prefix : <http://www.w3.org/ns/prov#> ."  > $turtle
rapper -q -g -o turtle $HOME/prov.owl           >> $turtle
perl -pi -e "s/prov-YYYYMMDD/$version/g"           $turtle
perl -pi -e "s/prov-YYYYmmdd/$prev/g"              $turtle

# $1: ontology URI
# $2: ontology location
function materialize_import { 
   #echo "$turtle += $1"
   echo "Including $1 from $2"
   echo                                         >> $turtle
   echo "# The following was imported from $1"  >> $turtle
   echo                                         >> $turtle
   curl -Ls $2 | grep -v "^@prefix"             >> $turtle
} 

# NOTE: These ontology-source mappings need to be stated in bin/prov-ns.xsl, too.
materialize_import 'http://www.w3.org/ns/prov-o#'          https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-o.ttl
materialize_import 'http://www.w3.org/ns/prov-o-inverses#' https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-o-inverses.ttl
materialize_import 'http://www.w3.org/ns/prov-aq#'         https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-aq.ttl
materialize_import 'http://www.w3.org/ns/prov-dc#'         https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-dc.ttl
materialize_import 'http://www.w3.org/ns/prov-dictionary#' https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-dictionary.ttl
materialize_import 'http://www.w3.org/ns/prov-links#'      https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-links.ttl

#prov-o.ttl
#prov-o-inverses.ttl
#prov-aq.ttl
#prov-dc.ttl
#prov-dictionary.ttl
#prov-links.ttl
