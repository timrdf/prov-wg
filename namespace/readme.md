
```
bash-3.2$ bin/prov-ns.sh --help
usage: prov-ns.sh [previous-version] [version]

  previous-version e.g. prov-20121211 (default: prov-YYYYmmdd)
           version e.g. prov-20130131 (default: prov-YYYYMMDD)
```

The following uses the file `prov.owl` and generates `prov.ttl` and releases/prov-YYYMMDD/*

```
bash-3.2$ bin/prov-ns.sh prov-20121211 prov-YYYYMMDD
Requesting http://www.w3.org/ns/prov-o.owl
   Found 114 rdf root elements
Requesting http://www.w3.org/ns/prov-o-inverses.owl
   Found 82 rdf root elements
Requesting http://dvcs.w3.org/hg/prov/raw-file/tip/paq/prov-aq.owl
   Found 31 rdf root elements
Requesting http://dvcs.w3.org/hg/prov/raw-file/tip/dictionary/prov-dictionary.owl
   Found 56 rdf root elements
```

