#!/bin/bash
#
#3> <> prov:specializationOf <https://github.com/timrdf/prov-wg/tree/master/namespace/bin>;
#3> .

# Permit running from prov-wg, prov-wg/namespace
PROV_NS=$(cd ${0%/*} && echo ${PWD%/*}) # e.g. prov-wg/namespace/bin/test-w3org.sh => prov-wg/namespace
if [[ "`basename $PROV_NS`" != 'namespace' ]]; then
   "$0 ERROR: could not situate into namespace/"
   exit 1
fi

w3c='w3c.org'
if [ ! -d $w3c ]; then
   mkdir $w3c
fi

function test_ns {
          mime="$1"
           url="$2"
   expectation="$3"

   base=`basename $url`
   ext='unk'
   pad=''
   if [   "$mime" == 'text/turtle'         ]; then
      ext='ttl';  pad='        '
   elif [ "$mime" == 'application/rdf+xml' ]; then
      ext='rdf';  pad=''
   elif [ "$mime" == 'application/xml'     ]; then
      ext='xsd';  pad='    '
   elif [ "$mime" == 'text/html'     ]; then
      ext='html'; pad='          '
   fi
   curl -sH "Accept: $mime" -L $url > $w3c/$base.$ext
   diffs=`diff --brief $w3c/$base.$ext $expectation`
   if [ ${#diffs} -gt 0 ]; then
      echo "FAIL: $mime $pad from $url does not match $expectation (diff $expectation $w3c/$base.$ext)"
   else
      echo "pass: $mime $pad from $url matches $expectation"
   fi
}

pushd $PROV_NS &> /dev/null
   #        mime                 url                                expectation
   test_ns 'text/html'           http://www.w3.org/2011/prov/errata ../errata.html
   echo

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

   test_ns 'text/turtle'         http://www.w3.org/ns/prov-aq  prov-aq.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-aq  prov-aq.owl
   echo

   test_ns 'text/turtle'         http://www.w3.org/ns/prov-dictionary  prov-dictionary.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-dictionary  prov-dictionary.owl
   echo

   test_ns 'text/turtle'         http://www.w3.org/ns/prov-links  prov-links.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-links  prov-links.owl
   test_ns 'application/xml'     http://www.w3.org/ns/prov-links  prov-links.xsd
   echo

   # prov-dc is an derived elaboration of prov-dc-refinements (by adding an owl:Ontology and prov:definitions)
   test_ns 'text/turtle'         http://www.w3.org/ns/prov-dc                 prov-dc.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-dc                 prov-dc.owl
   echo
   #
   # http://www.w3.org/TR/prov-dc/#bib-refinements
   test_ns 'text/turtle'         http://www.w3.org/ns/prov-dc-refinements     prov-dc-refinements.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-dc-refinements     prov-dc-refinements.owl
   echo
   #
   # http://www.w3.org/TR/prov-dc/#bib-mapping
   test_ns 'text/turtle'         http://www.w3.org/ns/prov-dc-directmappings  prov-dc-directmappings.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/ns/prov-dc-directmappings  prov-dc-directmappings.owl
   echo

   test_ns 'text/turtle'         http://www.w3.org/2011/prov/provenance/prov-o ../provenance/prov-o.ttl
   test_ns 'application/rdf+xml' http://www.w3.org/2011/prov/provenance/prov-o ../provenance/prov-o.rdf
   echo

   # TODO the rest of the provenance/ for the other 5+ components
popd &> /dev/null
