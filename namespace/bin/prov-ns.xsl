<!-- Timothy Lebo -->
<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:owl="http://www.w3.org/2002/07/owl#"
   xmlns:prov="http://www.w3.org/ns/prov#">
<xsl:output method="xml" indent="yes"/>

<xsl:param name="previous-version" select="'prov-20121211'"/>
<xsl:param name="version"          select="'prov-2012MMDD'"/>

<xsl:variable name="namespace" rdf:about="http://www.w3.org/ns/prov#">
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-o#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-o.owl"/>
   </prov:wasDerivedFrom> 
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-o-inverses#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-o-inverses.owl"/>
   </prov:wasDerivedFrom> 
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-aq#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-aq.owl"/>
   </prov:wasDerivedFrom> 
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-dc#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-dc.owl"/>
   </prov:wasDerivedFrom> 
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-dictionary#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-dictionary.owl"/>
   </prov:wasDerivedFrom> 
   <prov:wasDerivedFrom rdf:resource="http://www.w3.org/ns/prov-links#">
      <prov:hadLocation rdf:resource="https://dvcs.w3.org/hg/prov/raw-file/tip/namespace/prov-links.owl"/>
   </prov:wasDerivedFrom> 
</xsl:variable>

<xsl:key name="locations" match="prov:hadLocation" use="../@rdf:resource"/>

<xsl:template match="/rdf:RDF"> <!-- input is ../prov.owl; see prov-ns.sh -->
   <xsl:copy>
      <xsl:apply-templates select="*"/>
      <xsl:for-each select="owl:Ontology[@rdf:about='http://www.w3.org/ns/prov#']/prov:wasDerivedFrom/@rdf:resource">
         <xsl:value-of select="concat($NL,$NL,$NL,$NL,$NL,'   ')"/>
         <owl:Ontology rdf:about="{.}"/>
         <xsl:variable name="location" select="key('locations',.,$namespace)/@rdf:resource"/>
         <xsl:value-of select="concat($NL,$NL)"/>
         <xsl:comment>
            <xsl:value-of select="concat('The following was imported from ',.)"/> <!-- $location is actual location -->
            <xsl:message select="concat('Requesting ',$location)"/>
         </xsl:comment>
         <xsl:value-of select="concat($NL,$NL,'   ')"/>
         <xsl:variable name="import" select="doc($location)"/>
         <xsl:message select="concat('   Found ',count($import/rdf:RDF/*),' rdf root elements')"/>
         <xsl:apply-templates select="$import/rdf:RDF/*"/>
         <xsl:value-of select="$NL"/>
      </xsl:for-each>
   </xsl:copy>
</xsl:template>

<xsl:template match="owl:versionIRI[../@rdf:about='http://www.w3.org/ns/prov#']">
   <owl:versionIRI rdf:resource="{replace(@rdf:resource,'prov-YYYYMMDD',$version)}"/>
</xsl:template>

<xsl:template match="prov:wasRevisionOf[../@rdf:about='http://www.w3.org/ns/prov#']">
   <prov:wasRevisionOf rdf:resource="{replace(@rdf:resource,'prov-YYYYmmdd',$previous-version)}"/>
</xsl:template>

<!-- Identity template -->
<xsl:template match="@*|node()">
  <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:variable name="NL" select="'&#10;'"/>

</xsl:transform>
