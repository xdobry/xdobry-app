<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<!-- default database is mysql -->
<!-- Supported Databases 
mysql, MSSql, MSAccess, sqlite, Oracle, postgres
-->
<xsl:param name="database">mysqltcl</xsl:param> 
<xsl:param name="default">true</xsl:param> 
<xsl:param name="usesequence">false</xsl:param> 
<xsl:param name="autoincrement">auto_increment</xsl:param>
<xsl:param name="hasenum">true</xsl:param>
<!-- type for large text binary object BLOB -->
<xsl:param name="texttype">text</xsl:param>

<xsl:template match="/">
  <xsl:apply-templates select="/database//table"/>
  <!-- this one only for create changes statements -->
  <xsl:apply-templates select="/database/attr" mode="schema_table"/>
</xsl:template>

<xsl:template match="table">
<xsl:text>CREATE TABLE </xsl:text>
<xsl:apply-templates select="@name"/>
<xsl:text> (
</xsl:text>
<xsl:apply-templates select="attr"  mode="schema_table"/>
<xsl:if test="count(attr[@primary_key='1'])>0">
<xsl:text>,
    PRIMARY KEY (</xsl:text>
<xsl:apply-templates select="attr[@primary_key='1']" mode="primarykey"/>
<xsl:text>)</xsl:text>
</xsl:if>
<xsl:text>
);
</xsl:text>
<xsl:if test="$usesequence='true' and count(attr[@auto_increment='1'])>0"><xsl:text>CREATE SEQUENCE </xsl:text><xsl:value-of select="@name"/><xsl:text>_SEQ;
</xsl:text>
</xsl:if>
</xsl:template>

 <!--
 match columns
 -->
<xsl:template match="attr" mode="schema_table">
   <xsl:text>    </xsl:text>
   <xsl:apply-templates select="@name"/>
   <xsl:text> </xsl:text>
   <!-- MS Access has special type COUNTER for auto_increment also ignore typ and length -->
   <xsl:if test="not(@auto_increment) or @auto_increment='0' or $autoincrement!='COUNTER'">
	<xsl:apply-templates select="@type"/>
	<xsl:apply-templates select="@length"/>
   </xsl:if>
   <xsl:if test="$database='mysql'">
	 <xsl:apply-templates select="valuelist"/>
   </xsl:if> 
   <xsl:apply-templates select="@default"/>
   <xsl:apply-templates select="@auto_increment"/>
   <xsl:if test="not(@null)"> NOT NULL</xsl:if>
   <!-- search auto_increment='1' -->
   <xsl:if test="position()!=last()">,
</xsl:if>
</xsl:template>
<xsl:template match="@length">(<xsl:value-of select="."/>)</xsl:template>
<xsl:template match="valuelist">(<xsl:apply-templates select="item"/>)</xsl:template>
<xsl:template match="item">'<xsl:value-of select="."/>'<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
<!-- Type conversion -->
<xsl:template match="@type">
<xsl:param name="type"><xsl:value-of select="."/></xsl:param>
   <xsl:choose>
      <xsl:when test="$type='text'">
           <xsl:choose>
             <xsl:when test="$database='MSAccess'">
                 <xsl:text>memo</xsl:text>
             </xsl:when>
             <xsl:when test="$database='MSSql'">
                 <xsl:text>image</xsl:text>
             </xsl:when>
             <xsl:when test="$database='Oracle'">
                 <xsl:text>clob</xsl:text>
             </xsl:when>
             <xsl:otherwise>
	          <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='longblob'">
          <xsl:choose>
             <xsl:when test="$database='MSAccess'">
                 <xsl:text>image</xsl:text>
             </xsl:when>
             <xsl:when test="$database='MSSql'">
                 <xsl:text>image</xsl:text>
             </xsl:when>
             <xsl:when test="$database='postgres'">
                 <xsl:text>bytea</xsl:text>
             </xsl:when>
             <xsl:when test="$database='Oracle'">
                 <xsl:text>blob</xsl:text>
             </xsl:when>
             <xsl:otherwise>
	          <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='boolean'">
          <xsl:choose>
             <xsl:when test="$database='MSAccess' or $database='MSSql'">
                 <xsl:text>bit</xsl:text>
             </xsl:when>
             <xsl:when test="$database='Oracle'">
                 <xsl:text>number(1)</xsl:text>
             </xsl:when>
             <xsl:when test="$database='mysql'">
                 <xsl:text>smallint</xsl:text>
             </xsl:when>
             <xsl:otherwise>
	          <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='money'">
          <xsl:choose>
             <xsl:when test="$database!='MSAccess' and $database!='MSSql'">
                 <xsl:text>decimal(10,2)</xsl:text>
             </xsl:when>
             <xsl:otherwise>
	          <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='enum'">
          <xsl:choose>
             <xsl:when test="$database='mysql'">
                   <xsl:value-of select="$type"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:text>varchar(50)</xsl:text>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='set'">
          <xsl:choose>
             <xsl:when test="$database='mysql'">
                   <xsl:value-of select="$type"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:text>varchar(50)</xsl:text>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='timestamp'">
          <xsl:choose>
             <xsl:when test="$database='mysql' or $database='postgres'">
                   <xsl:value-of select="$type"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:text>datetime</xsl:text>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='varchar'">
          <xsl:choose>
             <xsl:when test="$database='Oracle'">
                 <xsl:text>varchar2</xsl:text>
             </xsl:when>
             <xsl:otherwise>
		 <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='datetime'">
          <xsl:choose>
             <xsl:when test="$database='postgres' or $database='Oracle'">
                 <xsl:text>timestamp</xsl:text>
             </xsl:when>
             <xsl:otherwise>
		 <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='float'">
          <xsl:choose>
             <xsl:when test="$database='MSAccess' or $database='MSSql'">
                 <xsl:text>real</xsl:text>
             </xsl:when>
             <xsl:otherwise>
                   <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="$type='double'">
          <xsl:choose>
             <xsl:when test="$database='MSAccess' or $database='MSSql'">
                 <xsl:text>float</xsl:text>
             </xsl:when>
             <xsl:otherwise>
                   <xsl:value-of select="$type"/>
             </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="$type"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>
<!-- no check on 1 -->
<xsl:template match="@null"> NOT NULL</xsl:template>
<!-- no check on 0 -->
<xsl:template match="@auto_increment"><xsl:text> </xsl:text><xsl:value-of select="$autoincrement"/></xsl:template>
<!-- !! value NULL without quotes -->
<xsl:template match="@default"><xsl:if test="$default='true'"> DEFAULT '<xsl:value-of select="."/>'</xsl:if></xsl:template>

<xsl:template match="attr" mode="primarykey">
<xsl:value-of select="@name"/>
<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="@name">
<xsl:choose>
  <xsl:when test="contains(.,' ')">
     <xsl:choose>
        <xsl:when test="$database='mysql' or $database='postgres' or $database='Oracle'">
           <xsl:value-of select="translate(.,' ','_')"/>
        </xsl:when>
        <xsl:otherwise>
           <xsl:text>[</xsl:text>
           <xsl:value-of select="."/>
           <xsl:text>]</xsl:text>
        </xsl:otherwise>
     </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="."/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>

