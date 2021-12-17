<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
 xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:cligs="https://cligs.hypotheses.org/ns/cligs" exclude-result-prefixes="xs h t xi cligs"
 xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

 <xsl:variable name="today">
  <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
 </xsl:variable>
 
 <xsl:variable name="context" select="/"/>

 <xsl:variable name="cligsId">
  <xsl:value-of select="//t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type = 'cligs']"/>
 </xsl:variable>

 <xsl:variable name="textId">
  <xsl:value-of select="concat('R19', substring($cligsId, 3,4))"/>
 </xsl:variable>
 
 <xsl:variable name="wordCount"><xsl:choose>
  <xsl:when test="/t:TEI/t:teiHeader/t:fileDesc/t:extent/t:measure[@unit = 'tokens']">
   <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:extent/t:measure[@unit = 'tokens']"/>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="t:countWords()"/></xsl:otherwise>
 </xsl:choose>
 </xsl:variable>
 


 <xsl:template match="t:TEI">
  <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="fr" xml:id="{$textId}" n="{$cligsId}">
   <xsl:apply-templates/>
  </TEI>
 </xsl:template>
 
 <xsl:template match="t:titleStmt">
  <titleStmt>
   <title>
    <xsl:value-of select="concat(t:title[@type = 'main'], ' : édition ELTeC')"/>
   </title>
   <author>
    <xsl:if test="string-length(t:author/t:idno[@type = 'viaf']) gt 2">
    <xsl:attribute name="ref">
     <xsl:value-of select="concat('viaf:', t:author/t:idno[@type = 'viaf'])"/>
    </xsl:attribute></xsl:if>
    <xsl:value-of select="concat(t:fixName(t:author/t:name[@type = 'full']), ' ', t:getAuthDates())"
    />
   </author>
  </titleStmt>
 </xsl:template>

 <xsl:template match="t:principal">
  <respStmt>
   <resp>principal</resp>
   <name>
    <xsl:apply-templates/>
   </name>
  </respStmt>
 </xsl:template>

 <xsl:template match="t:extent">
  <extent>
   <measure unit="words">
    <xsl:value-of select="t:measure[@unit eq 'tokens' or @unit eq 'words']"/>
   </measure>
  </extent>
 </xsl:template>

 <xsl:template match="t:publicationStmt">
  <xsl:if test="not(preceding-sibling::t:extent)">
   <extent>
    <measure unit="words">
<xsl:value-of select="$wordCount"/>  
    </measure>
   </extent>
  </xsl:if>
  <publicationStmt>
   <p>
    <xsl:text>Unpublished draft ELTeC conversion</xsl:text>
    <date>
     <xsl:value-of select="$today"/>
    </date>
   </p>
  </publicationStmt>
 </xsl:template>

 <xsl:template match="t:encodingDesc">
  <encodingDesc n="eltec-1">
   <p>Downcoded from CLIGS</p>
  </encodingDesc>
 </xsl:template>


 <xsl:template match="t:bibl">
  <bibl>
   <xsl:attribute name="type">
    <xsl:choose>
     <xsl:when test="@type = 'print-source'">printSource</xsl:when>
     <xsl:when test="@type = 'digital-source'">digitalSource</xsl:when>
     <xsl:when test="@type = 'edition-first'">firstEdition</xsl:when>
     <xsl:otherwise>
      <xsl:message>Unrecognised bibl type <xsl:value-of select="@type"/></xsl:message>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:apply-templates/>
  </bibl>
 </xsl:template>

 <xsl:template match="t:profileDesc">

  <xsl:variable name="date">
     <xsl:value-of select="t:getDatum(6)"/>
  </xsl:variable>
 
 
  <xsl:variable name="gender">
   <xsl:value-of select="t:textClass/t:keywords/t:term[@type = 'author.gender']"/>
  </xsl:variable>

  <xsl:variable name="timeSlot">
   <xsl:choose>
    <xsl:when test="$date le '1859'">T1</xsl:when>
    <xsl:when test="$date le '1879'">T2</xsl:when>
    <xsl:when test="$date le '1899'">T3</xsl:when>
    <xsl:when test="$date le '1920'">T4</xsl:when>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="size">
   <xsl:choose>
    <xsl:when test="xs:integer($wordCount) eq 0">undefined</xsl:when>
    <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
    <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
    <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="sex">
   <xsl:choose>
    <xsl:when test="$gender eq 'male'">M</xsl:when>
    <xsl:when test="$gender eq 'female'">F</xsl:when>
    <xsl:otherwise>U</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <profileDesc>
   <langUsage>
    <language ident="fra">French</language>
   </langUsage>
   <textDesc>
    <authorGender xmlns="http://distantreading.net/eltec/ns" key="{$sex}"/>
    <size xmlns="http://distantreading.net/eltec/ns" key="{$size}"/>
    <reprintCount xmlns="http://distantreading.net/eltec/ns" key="unspecified"/>
    <timeSlot xmlns="http://distantreading.net/eltec/ns" key="{$timeSlot}"/>
   </textDesc>
  </profileDesc>
 </xsl:template>

 <xsl:template match="t:change">
  <change when="{@when}">
   <xsl:value-of select="@who"/>
   <xsl:text> : </xsl:text>
   <xsl:value-of select="."/>
  </change>
 </xsl:template>
 
 <xsl:template match="t:revisionDesc">
  <revisionDesc>
   <change when="{$today}">Converted by cligstoeltec script</change>
   <xsl:for-each select="t:change">
    <xsl:sort order="descending" select="@when"/>
    <xsl:apply-templates select="."/>
   </xsl:for-each>
  </revisionDesc>
 </xsl:template>

 <xsl:template match="t:text">
  <text>
   <xsl:apply-templates/>
  </text>
 </xsl:template>

 <xsl:template match="t:front[not(t:div)]"/>

 <xsl:template match="t:front/t:div[not(@type)]">
  <div type="liminal">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 
 <xsl:template match="t:front/t:div[@type = 'preface']">
  <div type="liminal"><xsl:comment> preface </xsl:comment>
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 
 <xsl:template match="t:div[@type = 'dedication']">
 <div type="liminal"><xsl:comment> dedication </xsl:comment>
  <xsl:apply-templates/>
 </div>
 </xsl:template>
 
 <xsl:template match="t:div[@type='part']|t:div[@type='tome']|t:div[@type='division']">
  <div type="group">
   <xsl:apply-templates/>
  </div>  
 </xsl:template>

 
 <xsl:template match="t:body//t:div[not(@type)][t:div]">
  <div type="group">
   <xsl:apply-templates/>
  </div>  
 </xsl:template>
 
 <xsl:template match="t:div[@type='sub'][t:p]">
  <div type="chapter">
   <xsl:apply-templates/>
  </div>  
 </xsl:template>
 
 <xsl:template match="t:back/t:div[not(@type = 'notes')]">
  <div type="liminal">
   <xsl:apply-templates/>
  </div>
 </xsl:template>
 
 <xsl:template match="t:div[@type='section']">
  <milestone unit="section" />
  <label><xsl:value-of select="t:head"/></label>
   <xsl:apply-templates/>
</xsl:template>

 <xsl:template match="t:div[@type='section']/t:head"/>
 
 <xsl:template match="*:blockquote">
  <quote><xsl:apply-templates/></quote>
 </xsl:template>
 
 <xsl:template match="t:seg[@rend and not(@type)]">
  <hi>
   <xsl:apply-templates/>
  </hi>
 </xsl:template>

 <xsl:template match="t:seg[@type='italic']">
  <hi>
   <xsl:apply-templates/>
  </hi>
 </xsl:template>
 <xsl:template match="t:seg[@type = 'foreign']">
  <foreign>
   <xsl:if test="@xml:lang">
    <xsl:attribute name="xml:lang">
     <xsl:value-of select="@xml:lang"/>
    </xsl:attribute>
   </xsl:if>
   <xsl:apply-templates/>
  </foreign>
 </xsl:template>
 
 
 <xsl:template match="t:ab[@type = 'abstract']">
  <head type="summary">
   <xsl:apply-templates/>
  </head>
 </xsl:template>

 <xsl:template match="t:ab">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

<xsl:template match="t:speaker">
 <label><xsl:apply-templates/></label>
</xsl:template>

 <xsl:template match="t:stage">
  <hi><xsl:apply-templates/></hi>
 </xsl:template>
 
 
 <xsl:template match="t:floatingText | t:lg/t:head">
  <xsl:comment>
    <xsl:apply-templates/>
 </xsl:comment>
 </xsl:template>
 
 <xsl:template match="t:milestone[not(@unit)]">
  <milestone unit="undefined">
   <xsl:apply-templates select="@*"/>
  </milestone>
   
 </xsl:template>
 
 <!-- throw away tags but keep content -->
 
 <xsl:template match="t:lg|t:poem">
  <xsl:apply-templates/>
 </xsl:template>

<xsl:template match="t:sp">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="t:said">
 <milestone unit="qStart"/>
 <xsl:apply-templates/>
 <milestone unit="qEnd"/>
</xsl:template>
 
 <xsl:template match="t:seg[not(@rend) and not(@type)]">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="t:seg[@type = 'abbr']">
  <xsl:comment>abbr</xsl:comment>
  <xsl:apply-templates/>
 </xsl:template> 
 
 <xsl:template match="t:seg[@type = 'quotation']">
  <quote><xsl:apply-templates/></quote>
 </xsl:template> 
 
 <xsl:template match="t:seg[@type = 'dateline']">
  <xsl:comment>dateline</xsl:comment>
  <xsl:apply-templates/>
 </xsl:template> 
 
 <xsl:template match="t:seg[@type = 'signature']">
  <xsl:comment>signature</xsl:comment>
  <xsl:apply-templates/>
 </xsl:template> 
 
 <!-- throw away -->
 <xsl:template match="@default | @part | @status"/>
 <xsl:template match="t:ref[@target = '#']"/>
 
 
 <!-- copy everything else -->
 <xsl:template match="* | @*">
  <xsl:copy>
   <xsl:apply-templates select="* | @* | comment() | text()"/>
  </xsl:copy>
 </xsl:template>
 <xsl:template match="text()">
  <xsl:value-of select="."/>
  <!-- could normalize() here -->
 </xsl:template>

 <xsl:function name="t:getAuthDates">
  <xsl:value-of
   select="
    concat('(', document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = '48'], '-',
    document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = '49'], ')')"
  />
 </xsl:function>

 <xsl:function name="t:getDatum">
  <xsl:param name="column"/>
  <xsl:value-of
   select="document('metadata.xml')//t:row[t:cell[@n = '2'][contains(., $cligsId)]]/t:cell[@n = $column]"
  />
 </xsl:function>

 <xsl:function name="t:fixName">
  <xsl:param name="name"/>
  <xsl:choose>
   <xsl:when test="contains($name, ',')">
    <xsl:value-of select="$name"/>
   </xsl:when>
   <xsl:when test="contains($name, ' de ')">
    <xsl:value-of
     select="concat(substring-after($name, ' de '), ', ', substring-before($name, ' de '), ' de')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="concat(substring-after($name, ' '), ', ', substring-before($name, ' '))"/>
   </xsl:otherwise>
   <!-- works for "Benito Perez Galdos" but not for "Jacinto Octavio Picon" -->

  </xsl:choose>
 </xsl:function>
 
 <xsl:function name="t:countWords">
    <xsl:value-of select=
   " string-length(normalize-space($context/t:TEI/t:text))
   -
   string-length(translate(normalize-space($context/t:TEI/t:text),' ','')) +1"/>
 </xsl:function>
</xsl:stylesheet>
