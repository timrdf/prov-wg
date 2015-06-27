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

if [[ "$1" == "--help" ]]; then
   echo "usage: `basename $0` [previous-version] [version]"
   echo
   echo "  previous-version e.g. prov-20121211 (default: $prev)"
   echo "           version e.g. prov-20130131 (default: $version)"
   exit
elif [[ $# -eq 2 ]]; then
   prev=$1
   version=$2
else
   echo
   echo "WARNING: using default version identifiers; see `basename $0` --help"
   echo
fi

HOME=$(cd ${0%/*} && echo ${PWD%/*})

release=$HOME/releases/$version/prov.owl
mkdir -p `dirname $release` 

java -jar $HOME/lib/saxon9.jar $HOME/prov.owl $HOME/bin/prov-ns.xsl "previous-version=$prev version=$version" > $release

function representation_for {
   ontology_uri="$1"
   grep -A1 "$ontology_uri" bin/prov-ns.xsl | tail -1 | sed 's/^.*rdf:resource="//;s/".*$//;s/owl$/ttl/'
}

release=${release##`pwd`/}
echo && echo $release

turtle=${release%.owl}.ttl
echo && echo "$turtle << $release"
echo "@prefix : <http://www.w3.org/ns/prov#> ."            > $turtle
rapper -q  -g -o turtle $HOME/prov.owl                    >> $turtle
perl   -pi -e "s/prov-YYYYMMDD/$version/g"                   $turtle
perl   -pi -e "s/prov-YYYYmmdd/$prev/g"                      $turtle
                                                                #
function materialize_import {                                   #
   ontology_uri="$1"                                            #
   url=`representation_for $ontology_uri`                       #
   echo "$turtle += $ontology_uri"                              #
   echo "                                   $url"               #
   echo                                                   >> $turtle
   echo "# The following was imported from $ontology_uri" >> $turtle
   echo                                                   >> $turtle
   curl -Ls $url | grep -v "^@prefix"                     >> $turtle
} 

for component in o o-inverses aq dc dictionary links; do
   materialize_import "http://www.w3.org/ns/prov-$component#"
done
