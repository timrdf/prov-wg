#!/bin/bash

if [ ! -d test ]; then
   mkdir test
fi

function test_ns {
   mime="$1"
   url="$2"
   goal="$3"

   base=`basename $url`
   ext='unk'
   pad=''
   if [   "$mime" == 'text/turtle'         ]; then
      ext='ttl'; pad='        '
   elif [ "$mime" == 'application/rdf+xml' ]; then
      ext='rdf'; pad=''
   elif [ "$mime" == 'application/xml'     ]; then
      ext='xsd'; pad='    '
   fi
   curl -sH "Accept: $mime" -L $url > test/$base.$ext
   diffs=`diff --brief test/$base.$ext $goal`
   if [ ${#diffs} -gt 0 ]; then
      echo "FAIL: $mime $pad from $url does not match $goal (diff $goal test/$base.$ext)"
   else
      echo "pass: $mime $pad from $url matches $goal"
   fi
}

#        mime                  url                        diff
test_ns 'text/turtle'         http://www.w3.org/ns/prov  releases/prov-20130430/prov.ttl
test_ns 'application/rdf+xml' http://www.w3.org/ns/prov  releases/prov-20130430/prov.owl
test_ns 'application/xml'     http://www.w3.org/ns/prov  prov.xsd
echo

test_ns 'text/turtle'         http://www.w3.org/ns/prov-o  prov-o.ttl
test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-o  prov-o.owl
echo

test_ns 'text/turtle'         http://www.w3.org/ns/prov-o-inverses  prov-o-inverses.ttl
test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-o-inverses  prov-o-inverses.owl
echo

test_ns 'text/turtle'         http://www.w3.org/ns/prov-links  prov-links.ttl
test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-links  prov-links.owl
test_ns 'application/xml'     http://www.w3.org/ns/prov-links  prov-links.xsd
echo

test_ns 'text/turtle'         http://www.w3.org/2011/prov/provenance/prov-o ../provenance/prov-o.ttl
test_ns 'application/rdf+xml' http://www.w3.org/2011/prov/provenance/prov-o ../provenance/prov-o.rdf
echo

