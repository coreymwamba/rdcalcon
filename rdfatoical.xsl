<?xml version="1.0"?>
<xsl:stylesheet 
 xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" 
 xmlns:cal="http://www.w3.org/2002/12/cal/ical#"
 xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
 version="1.0"
>

<xsl:output
  encoding="UTF-8"
  indent="no"
  media-type="text/calendar"
  method="text"
/>

<xsl:param name="prodid" select='"-//coreymwamba.co.uk//rdfatoical (ALPHA)//EN"' />

<!--  by Corey Mwamba, based on Dan Connolly's work with microformats here: -->
<!-- http://dev.w3.org/cvsweb/2001/palmagent/toICal.xsl?rev=1.9;content-type=text%2Fplain -->
<!-- BUT THEN OH MY GOD. The sheer amount of wrangling I've had to with this damned thing is insane. -->
<!-- Literally insane. -->


<xsl:template match="*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
  <xsl:text>BEGIN:VCALENDAR</xsl:text>
    
  <xsl:text>&#x0A;PRODID:</xsl:text>
  <xsl:value-of select="$prodid" />
   
<!-- Now to include the method. -->
<!-- This is where RDFa really trumps microformats. -->
<!-- New updates to the iCalendar format mean that METHOD could be used much more -->
<!-- for instance, look at http://tools.ietf.org/html/rfc5546#section-3.2 -->
<!-- if RFC-5546 becomes the norm then I can move TIMELINE to an X-PROP -->
<!-- but with microformats none of this is possible -->

 <xsl:call-template name="methodProp">
      <xsl:with-param name="label">METHOD</xsl:with-param>
      <xsl:with-param name="property">method</xsl:with-param>
    </xsl:call-template>

  <xsl:text>&#x0A;VERSION:2.0</xsl:text>
  <xsl:apply-templates />
  
  <xsl:text>&#x0A;END:VCALENDAR&#x0A;</xsl:text>

</xsl:template>



<!-- Each event is listed in succession: however, there are quite a few ways to express a calendar. -->
<!-- in addition, I now think that there's no reason to have a capital V. It's that kind of thinking -->
<!-- that upsets people. -->



<!-- so we have to do this more than once. I've done it twice: one for when elements are @related (e.g. list items: you'd efficiently set @rel=Vevent) -->

<xsl:template match="*[contains(@rel,'Vevent') or contains(@rel,'vevent')]/*">
    <xsl:if test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VEVENT</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VEVENT</xsl:text>
</xsl:if>
</xsl:template>


<!--  and one for when people set @typeof as Vevent... -->

<xsl:template match="//*[contains(@typeof,'Vevent') or contains(@typeof,'vevent')]">

<xsl:choose>
<xsl:when test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VEVENT</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VEVENT</xsl:text>
</xsl:when>
<xsl:otherwise>
  <xsl:text>BEGIN:VCALENDAR</xsl:text>
    
  <xsl:text>&#x0A;PRODID:</xsl:text>
  <xsl:value-of select="$prodid" />

 <xsl:call-template name="methodProp">
      <xsl:with-param name="label">METHOD</xsl:with-param>
      <xsl:with-param name="property">method</xsl:with-param>
    </xsl:call-template>

  <xsl:text>&#x0A;VERSION:2.0</xsl:text>
    <xsl:text>&#x0A;BEGIN:VEVENT</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VEVENT</xsl:text>
  <xsl:text>&#x0A;END:VCALENDAR&#x0A;</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>



<!-- to-do listings -->
<xsl:template match="*[contains(@rel,'Vtodo') or contains(@rel,'vtodo')]/*">
    <xsl:if test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VTODO</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VTODO</xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="//*[contains(@typeof,'Vtodo') or contains(@typeof,'vtodo')]">

<xsl:choose>
<xsl:when test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VTODO</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VTODO</xsl:text>
</xsl:when>
<xsl:otherwise>
  <xsl:text>BEGIN:VCALENDAR</xsl:text>
    
  <xsl:text>&#x0A;PRODID:</xsl:text>
  <xsl:value-of select="$prodid" />

 <xsl:call-template name="methodProp">
      <xsl:with-param name="label">METHOD</xsl:with-param>
      <xsl:with-param name="property">method</xsl:with-param>
    </xsl:call-template>

  <xsl:text>&#x0A;VERSION:2.0</xsl:text>
    <xsl:text>&#x0A;BEGIN:VTODO</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VTODO</xsl:text>
  <xsl:text>&#x0A;END:VCALENDAR&#x0A;</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- journals -->
<xsl:template match="*[contains(@rel,'Vjournal') or contains(@rel,'vjournal')]/*">
    <xsl:if test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VJOURNAL</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VJOURNAL</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="//*[contains(@typeof,'Vjournal') or contains(@typeof,'vjournal')]">

<xsl:choose>
<xsl:when test="ancestor::*[contains(@typeof,'Vcalendar') or contains(@typeof,'vcalendar')]">
    <xsl:text>&#x0A;BEGIN:VJOURNAL</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VJOURNAL</xsl:text>
</xsl:when>
<xsl:otherwise>
  <xsl:text>BEGIN:VCALENDAR</xsl:text>
    
  <xsl:text>&#x0A;PRODID:</xsl:text>
  <xsl:value-of select="$prodid" />

 <xsl:call-template name="methodProp">
      <xsl:with-param name="label">METHOD</xsl:with-param>
      <xsl:with-param name="property">method</xsl:with-param>
    </xsl:call-template>

  <xsl:text>&#x0A;VERSION:2.0</xsl:text>
    <xsl:text>&#x0A;BEGIN:VJOURNAL</xsl:text>
    <xsl:call-template name="cal-props" />
    <xsl:text>&#x0A;END:VJOURNAL</xsl:text>
  <xsl:text>&#x0A;END:VCALENDAR&#x0A;</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>













<xsl:template name="cal-props">

    <!-- UID and DTSTAMP are required in RFC-5545. -->

      <xsl:text>&#x0A;UID:</xsl:text>
        <xsl:choose>
          <xsl:when test="@about">
            <xsl:value-of select='concat($Source,@about)' />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select='concat($Source, "#", @id)' />
          </xsl:otherwise>
        </xsl:choose>

<xsl:choose>
<xsl:when test="ancestor-or-self::*[contains(@property, 'dtstamp')]">
   <xsl:call-template name="stampProp">
      <xsl:with-param name="label">DTSTAMP</xsl:with-param>
      <xsl:with-param name="property">dtstamp</xsl:with-param>
    </xsl:call-template>
</xsl:when>
<xsl:otherwise>
    <xsl:text>&#x0A;DTSTAMP:</xsl:text>
      <xsl:value-of select="$Stamp" />
</xsl:otherwise>
</xsl:choose>

<!-- Everything else is optional. -->
<!--In fact, DTSTART is OPTIONAL in RFC-2445 and optional if you include a METHOD in RFC-5545. -->
<!-- But in microformats, dtstart is required. So it's not an exact mapping of either spec. -->
 
  <xsl:call-template name="textProp">
      <xsl:with-param name="label">SUMMARY</xsl:with-param>
      <xsl:with-param name="property">summary</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="textProp">
      <xsl:with-param name="label">DESCRIPTION</xsl:with-param>
      <xsl:with-param name="property">description</xsl:with-param>
    </xsl:call-template>

  <xsl:call-template name="textProp">
      <xsl:with-param name="label">CATEGORIES</xsl:with-param>
      <xsl:with-param name="property">categories</xsl:with-param>
    </xsl:call-template>

  <xsl:call-template name="textProp">
      <xsl:with-param name="label">COMMENT</xsl:with-param>
      <xsl:with-param name="property">comment</xsl:with-param>
    </xsl:call-template> 

    <xsl:call-template name="methodProp">
      <xsl:with-param name="label">STATUS</xsl:with-param>
      <xsl:with-param name="property">status</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="methodProp">
      <xsl:with-param name="label">CLASS</xsl:with-param>
      <xsl:with-param name="property">class</xsl:with-param>
    </xsl:call-template>

   <xsl:call-template name="dateProp">
      <xsl:with-param name="label">DTSTART</xsl:with-param>
      <xsl:with-param name="property">dtstart</xsl:with-param>
    </xsl:call-template>


    <xsl:call-template name="dateProp">
      <xsl:with-param name="label">DTEND</xsl:with-param>
      <xsl:with-param name="property">dtend</xsl:with-param>
    </xsl:call-template>



    <xsl:call-template name="durProp">
      <xsl:with-param name="label">DURATION</xsl:with-param>
      <xsl:with-param name="property">duration</xsl:with-param>
    </xsl:call-template>


<!-- this is the time-line property I want to use. -->

    <xsl:call-template name="durProp">
      <xsl:with-param name="label">X-TIMELINE-OFFSET</xsl:with-param>
      <xsl:with-param name="property">x-timeline-offset</xsl:with-param>
    </xsl:call-template>

   <xsl:call-template name="attendProp">
      <xsl:with-param name="label">ATTENDEE</xsl:with-param>
      <xsl:with-param name="property">attendee</xsl:with-param>
    </xsl:call-template>


   <xsl:call-template name="attendProp">
      <xsl:with-param name="label">ORGANIZER</xsl:with-param>
      <xsl:with-param name="property">organizer</xsl:with-param>
    </xsl:call-template>

   <xsl:call-template name="rruleProp">
      <xsl:with-param name="label">RRULE</xsl:with-param>
      <xsl:with-param name="property">rrule</xsl:with-param>
    </xsl:call-template>



    <xsl:call-template name="refProp">
      <xsl:with-param name="label">URL</xsl:with-param>
      <xsl:with-param name="property">url</xsl:with-param>
      <xsl:with-param name="default">
        <xsl:choose>
          <xsl:when test="@about">
            <xsl:value-of select='concat($Source, @about)' />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select='concat($Source, "#", @id)' />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="textProp">
      <xsl:with-param name="label">LOCATION</xsl:with-param>
      <xsl:with-param name="property">location</xsl:with-param>
    </xsl:call-template>

</xsl:template>

<!-- attendance -->
<xsl:template name="attendProp">
  <xsl:param name="label" />
  <xsl:param name="property" />
  <xsl:for-each select="*[contains(translate(@rel,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]/*">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />
<xsl:if test="child::*">
     <xsl:text>;</xsl:text>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">cn</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">dir</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="ac-subProp">
      <xsl:with-param name="subprop">role</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="ac-subProp">
      <xsl:with-param name="subprop">partstat</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="ac-subProp">
      <xsl:with-param name="subprop">rsvp</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="ac-subProp">
      <xsl:with-param name="subprop">cutype</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">member</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">delegated-from</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">delegated-to</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="a-subProp">
      <xsl:with-param name="subprop">sent-by</xsl:with-param>
    </xsl:call-template>
</xsl:if>
    <xsl:text>:</xsl:text>
<xsl:choose>
          <xsl:when test=".//@about">
            <xsl:value-of select=".//@about" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select=".//@href" />
          </xsl:otherwise>
        </xsl:choose>
</xsl:for-each>
</xsl:template>




<xsl:template name="a-subProp">
  <xsl:param name="subprop" />
<xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$subprop)]">
<xsl:value-of select="translate($subprop,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
<xsl:text>=</xsl:text>
<xsl:choose>
<xsl:when test="./@content">
    <xsl:value-of select="./@content" />
</xsl:when>
<xsl:otherwise>
    <xsl:value-of select="." />
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="following-sibling::*[contains(@property,'dir') or contains(@property,'cn') or contains(@property,'delegated') or contains(@property,'sent')  or contains(@property,'partstat') or contains(@property,'member')]">
    <xsl:text>;</xsl:text>
</xsl:when>
<xsl:when test="descendant::*[contains(@property,'dir') or contains(@property,'cn') or contains(@property,'delegated') or contains(@property,'sent')  or contains(@property,'partstat') or contains(@property,'member')]">
    <xsl:text>;</xsl:text>
</xsl:when>
</xsl:choose></xsl:for-each>
</xsl:template>


<xsl:template name="ac-subProp">
  <xsl:param name="subprop" />
<xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$subprop)]">

<xsl:value-of select="translate($subprop,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
<xsl:text>=</xsl:text>
<xsl:choose>
<xsl:when test="./@content">
    <xsl:value-of select="translate(./@content,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
</xsl:when>
<xsl:otherwise>
    <xsl:value-of select="translate(.,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="following-sibling::*[contains(@property,'dir') or contains(@property,'cn') or contains(@property,'delegated') or contains(@property,'sent')  or contains(@property,'partstat') or contains(@property,'member')]">
    <xsl:text>;</xsl:text>
</xsl:when>
<xsl:when test="descendant::*[contains(@property,'dir') or contains(@property,'cn') or contains(@property,'delegated') or contains(@property,'sent')  or contains(@property,'partstat') or contains(@property,'member')]">
    <xsl:text>;</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>



</xsl:template>


<!-- recurrence. rrules have to be @related to the Vevent, and be a container for its properties -->

<xsl:template name="rruleProp">
  <xsl:param name="label" />
  <xsl:param name="property" />

  <xsl:for-each select="descendant-or-self::*[contains(translate(@rel,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">

    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />
    <xsl:text>:</xsl:text>
<!-- and then...
       recur-rule-part = ( "FREQ" "=" freq )
                       / ( "UNTIL" "=" enddate )
                       / ( "COUNT" "=" 1*DIGIT )
                       / ( "INTERVAL" "=" 1*DIGIT )
                       / ( "BYSECOND" "=" byseclist )
                       / ( "BYMINUTE" "=" byminlist )
                       / ( "BYHOUR" "=" byhrlist )
                       / ( "BYDAY" "=" bywdaylist )
                       / ( "BYMONTHDAY" "=" bymodaylist )
                       / ( "BYYEARDAY" "=" byyrdaylist )
                       / ( "BYWEEKNO" "=" bywknolist )
                       / ( "BYMONTH" "=" bymolist )
                       / ( "BYSETPOS" "=" bysplist )
                       / ( "WKST" "=" weekday ) -->



    <xsl:call-template name="freq" />

    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">interval</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">until</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">count</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">bysecond</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">byminute</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">byhour</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">byday</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">bymonthday</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">byyearday</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">byweekno</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">bymonth</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">bysetpos</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="r-subProp">
      <xsl:with-param name="subprop">wkst</xsl:with-param>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>


<xsl:template name="freq">
  <xsl:variable name="frequency" select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'freq')]" />
    <xsl:variable name="fr" select="$frequency/@content" />
    <xsl:text>FREQ=</xsl:text>
    <xsl:value-of select="translate($fr,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
<xsl:choose>
<xsl:when test="following-sibling::*[contains(@property,'interval') or contains(@property,'until') or contains(@property,'count') or contains(@property,'bysec') or contains(@property,'byhour') or contains(@property,'byminute')  or contains(@property,'byday') or contains(@property,'byweekno') or contains(@property,'bymonth') or contains(@property,'bymonthday') or contains(@property,'byyearday') or contains(@property,'bysetpos') or contains(@property,'wkst')]">
    <xsl:text>;</xsl:text>
</xsl:when>
<xsl:when test="descendant::*[contains(@property,'interval') or contains(@property,'until') or contains(@property,'count') or contains(@property,'bysec') or contains(@property,'byhour') or contains(@property,'byminute')  or contains(@property,'byday') or contains(@property,'byweekno') or contains(@property,'bymonth') or contains(@property,'bymonthday') or contains(@property,'byyearday') or contains(@property,'bysetpos') or contains(@property,'wkst')]">
    <xsl:text>;</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template name="r-subProp">
  <xsl:param name="subprop" />
  <xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$subprop)]">
  <xsl:if test="preceding-sibling::*[1]">
    <xsl:text>;</xsl:text>
</xsl:if>
<xsl:value-of select="translate($subprop,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
<xsl:text>=</xsl:text>
    <xsl:value-of select="translate(./@content,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />

</xsl:for-each>
</xsl:template>




<xsl:template name="methodProp">
  <xsl:param name="label" />
  <xsl:param name="property" />


  <xsl:for-each select="*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">

    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />
    <xsl:text>:</xsl:text>

    <xsl:choose>
          <xsl:when test='@content'>
	<xsl:variable name="v" select="normalize-space(@content)" />
	<xsl:call-template name="escapeText">
	  <xsl:with-param name="text-string" select="translate($v,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
	</xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="v" select="normalize-space(.)" />
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="translate($v,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>





<xsl:template name="textProp">
  <xsl:param name="label" />
  <xsl:param name="property" />

  <xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">

    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />

    <xsl:call-template name="lang" />

    <xsl:text>:</xsl:text>

    <xsl:choose>
      <!-- @@this multiple values stuff doesn't seem to be in the spec
      -->
      <xsl:when test='local-name(.) = "ol" or local-name(.) = "ul"'>
        <xsl:for-each select="*">
          <xsl:if test="not(position()=1)">
            <xsl:text>,</xsl:text>
          </xsl:if>

          <xsl:call-template name="escapeText">
            <xsl:with-param name="text-string" select="." />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>

      <xsl:when test='@content'>
	<xsl:variable name="v"
		      select="normalize-space(@content)" />
	<xsl:call-template name="escapeText">
	  <xsl:with-param name="text-string" select="$v" />
	</xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="v"
                      select="normalize-space(.)" />
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="$v" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>


<xsl:template name="lang">
  <xsl:variable name="langElt"
                select='ancestor-or-self::*[@xml:lang or @lang]' />
  <xsl:if test="$langElt">
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="$langElt/@xml:lang">
          <xsl:value-of select="normalize-space($langElt/@xml:lang)" />
        </xsl:when>
        <xsl:when test="$langElt/@lang">
          <xsl:value-of select="normalize-space($langElt/@lang)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>where id lang and xml:lang go?!?!?
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>;LANGUAGE=</xsl:text>
    <xsl:value-of select="$lang" />
  </xsl:if>
</xsl:template>


<xsl:template name="refProp">
  <xsl:param name="label" />
  <xsl:param name="property" />
  <xsl:param name="default" />

  <xsl:choose>
    <xsl:when test="descendant-or-self::*[contains(@property, $property)]">

      <xsl:for-each select="descendant-or-self::*[contains(@property, $property)]">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:value-of select="$label" />
        
        <xsl:variable name="ref">
          <xsl:choose>
            <!-- @@make absolute? -->
            <xsl:when test="@href">
              <xsl:value-of select="@href" />
            </xsl:when>
            
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:text>:</xsl:text>
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="$ref" />
        </xsl:call-template>
        
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="$default">
      <xsl:text>&#x0A;</xsl:text>
      <xsl:value-of select="$label" />
      <xsl:text>:</xsl:text>
      <xsl:call-template name="escapeText">
        <xsl:with-param name="text-string" select="$default" />
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>

</xsl:template>


<xsl:template name="dateProp">
  <xsl:param name="label" />
  <xsl:param name="property" />

  <!-- @@ case sensitive class matching? -->
 <xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">

    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />
    <xsl:variable name="when">
      <xsl:choose>
	<xsl:when test="@content">
	  <xsl:value-of select="@content">
	  </xsl:value-of>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test='contains($when, "Z")'>
        <xsl:text>;VALUE=DATE-TIME:</xsl:text>
        <xsl:value-of select='translate($when, "-:", "")' />
      </xsl:when>

      <xsl:when test='string-length($when) =
                      string-length("yyyy-mm-ddThh:mm:ss+hhmm")'>
        <xsl:text>;VALUE=DATE-TIME:</xsl:text>
        <xsl:call-template name="timeDelta">
          <xsl:with-param name="year"
                          select='number(substring($when, 1, 4))'/>
          <xsl:with-param name="month"
                          select='number(substring($when, 6, 2))'/>
          <xsl:with-param name="day"
                          select='number(substring($when, 9, 2))'/>
          <xsl:with-param name="hour"
                          select='number(substring($when, 12, 2))'/>
          <xsl:with-param name="minute"
                          select='number(substring($when, 15, 2))'/>

          <xsl:with-param name="hourDelta"
                          select='number(substring($when, 21, 2))'/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test='contains($when, "T")'>
        <xsl:text>;VALUE=DATE-TIME:</xsl:text>
        <xsl:value-of select='translate($when, "-:", "")' />
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>;VALUE=DATE:</xsl:text>
        <xsl:value-of select='translate($when, "-:", "")' />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>

<xsl:template name="stampProp">
  <xsl:param name="label" />
  <xsl:param name="property" />

 <xsl:for-each select="descendant-or-self::*[contains(@property,$property)]">

    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />
<xsl:text>:</xsl:text>
    <xsl:variable name="when">
      <xsl:choose>
	<xsl:when test="@content">
	  <xsl:value-of select="@content">
	  </xsl:value-of>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(.)" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test='contains($when, "Z")'>
        <xsl:value-of select='translate($when, "-:", "")' />
      </xsl:when>

      <xsl:when test='string-length($when) =
                      string-length("yyyy-mm-ddThh:mm:ss+hhmm")'>
        <xsl:call-template name="timeDelta">
          <xsl:with-param name="year"
                          select='number(substring($when, 1, 4))'/>
          <xsl:with-param name="month"
                          select='number(substring($when, 6, 2))'/>
          <xsl:with-param name="day"
                          select='number(substring($when, 9, 2))'/>
          <xsl:with-param name="hour"
                          select='number(substring($when, 12, 2))'/>
          <xsl:with-param name="minute"
                          select='number(substring($when, 15, 2))'/>

          <xsl:with-param name="hourDelta"
                          select='number(substring($when, 21, 2))'/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test='contains($when, "T")'>
         <xsl:value-of select='translate($when, "-:", "")' />
      </xsl:when>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>


<xsl:template name="timeDelta">
  <!-- see http://www.microformats.org/wiki/datetime-design-pattern -->
  <!-- returns YYYYMMDDThhmmssZ -->
  <xsl:param name="year" /> <!-- integers -->
  <xsl:param name="month" />
  <xsl:param name="day" />
  <xsl:param name="hour" />
  <xsl:param name="minute" />

  <xsl:param name="hourDelta" />

  <xsl:variable name="hour2">
    <xsl:choose>
      <xsl:when test="$hour + $hourDelta &gt; 23">
        <xsl:value-of select="$hour + $hourDelta - 24" />
      </xsl:when>
      <xsl:when test="$hour + $hourDelta &lt; 0">
        <xsl:value-of select="$hour + $hourDelta + 24" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$hour + $hourDelta" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dayDelta">
    <xsl:choose>
      <xsl:when test="$hour + $hourDelta &gt; 23">
        <xsl:value-of select="1" />
      </xsl:when>
      <xsl:when test="$hour + $hourDelta &lt; 0">
        <xsl:value-of select="-1" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="maxd">
    <xsl:call-template name="max-days">
      <xsl:with-param name="y" select="$year"/>
      <xsl:with-param name="m" select="$month"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="day2">
    <xsl:choose>
      <xsl:when test="$day + $dayDelta &gt; $maxd">
        <xsl:value-of select="1" />
      </xsl:when>

      <xsl:when test="$day + $dayDelta &lt; 0">
        <xsl:call-template name="max-days">
          <xsl:with-param name="y" select="$y"/>
          <!-- @@TODO: handle year crossings -->
          <xsl:with-param name="m" select="$m - 1"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$day + $dayDelta" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="monthDelta">
    <xsl:choose>
      <xsl:when test="$day + $dayDelta &gt; $maxd">
        <xsl:value-of select="1" />
      </xsl:when>
      <xsl:when test="$day + $dayDelta &lt; 0">
        <xsl:value-of select="-1" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="month2">
    <xsl:choose>
      <xsl:when test="$month + $monthDelta &gt; 12">
        <xsl:value-of select="1" />
      </xsl:when>

      <xsl:when test="$month + $monthDelta &lt; 0">
        <xsl:value-of select="12" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$month + $monthDelta" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="yearDelta">
    <xsl:choose>
      <xsl:when test="$month + $monthDelta &gt; 12">
        <xsl:value-of select="1" />
      </xsl:when>

      <xsl:when test="$month + $monthDelta &lt; 0">
        <xsl:value-of select="-1" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="0" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="year2">
    <xsl:value-of select="$year + $yearDelta" />
  </xsl:variable>

  <xsl:value-of select='concat(format-number($year2, "0000"),
                        format-number($month2, "00"),
                        format-number($day2, "00"), "T",
                        format-number($hour2, "00"),
                        format-number($minute, "00"), "00Z")' />

</xsl:template>


<xsl:template name="max-days">
  <!-- maximum number of days in the given month of the given year -->
  <!-- @@ skip leap year for now -->
  <xsl:param name="y" select="$y"/>
  <xsl:param name="m" select="$m"/>

  <xsl:choose>
    <xsl:when test='$m = 1 or $m = 3 or $m = 5 or $m = 7 or
      $m = 8 or $m = 10 or $m = 12'>
      <xsl:value-of select="31" />
    </xsl:when>

    <xsl:when test='$m = 2'>
      <xsl:value-of select="28" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="30" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>





<xsl:template name="durProp">
  <xsl:param name="label" />
  <xsl:param name="property" />

  <!-- @@ case sensitive class matching? -->
  <xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />

    <xsl:text>:</xsl:text>
    <!-- commas aren't possible, are they? -->
    <xsl:choose>
      <xsl:when test='@content'>
        <xsl:value-of select="@content" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select='normalize-space(.)' />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>

<xsl:template name="blobProp">
  <xsl:param name="label" />
  <xsl:param name="class" />

  <!-- @@ case sensitive class matching? -->
  <xsl:for-each select="descendant-or-self::*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />

    <xsl:choose>
      <xsl:when test="@src">
        <xsl:text>;VALUE=uri:</xsl:text>
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="@src" />
        </xsl:call-template>
      </xsl:when>

      <!-- hmm... href? -->

      <xsl:otherwise>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<xsl:template name="emailProp">
  <xsl:param name="label" />
  <xsl:param name="class" />

  <!-- @@ case sensitive class matching? -->
  <xsl:for-each select=".//*[contains(translate(@property,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),$property)]">
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="$label" />

    <!-- @@TYPE=x.400 not supported -->

    <xsl:choose>
      <xsl:when test='@href and starts-with(@href, "mailto:")'>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string"
                          select='substring-after(@href, ":")' />
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="escapeText">
          <xsl:with-param name="text-string" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<xsl:template name="escapeText">
  <xsl:param name="text-string"></xsl:param>
  <xsl:choose>
    <xsl:when test="substring-before($text-string,',') = true()">
      <xsl:value-of select="substring-before($text-string,',')"/>
      <xsl:text>\,</xsl:text>
      <xsl:call-template name="escapeText">
        <xsl:with-param name="text-string">
          <xsl:value-of select="substring-after($text-string,',')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text-string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" />


</xsl:stylesheet>