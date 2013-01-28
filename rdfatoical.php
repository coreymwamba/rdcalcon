<?php
// rdfatoical by Corey Mwamba - http://www.coreymwamba.co.uk/contact
// converts HTML with Calendar RDFa into iCalendar files - and includes timeline proposal idea
// Just remove the .txt part from the file name to make it work on your server

header("Content-Type: text/calendar");
header('Content-Disposition: attachment; filename="rdfatoical-'.time().'.ics"');
function url_get_contents ($Url) {
    if (!function_exists('curl_init')){ 
        die('CURL is not installed!');
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $Url);
    curl_setopt($ch, CURLOPT_HTTPHEADER,array (
         "Accept: application/xhtml+xml"
     ));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

$file = $_GET['url'];
$frag = explode ('#',$file);

if (empty($frag[1])){
$req = url_get_contents($frag[0]);
$sxe = new DOMDocument;
$sxe->loadXML($req);
}


else {
$req = url_get_contents($frag[0]);
$axe = new DOMDocument;
$axe->loadXML($req);

$xpath = new DOMXpath($axe);
$xq = "//*[@id = '".$frag[1]."']";
$result = $xpath->query($xq);
$keepme = $result->item(0);

$sxe = new DOMDocument();
$tempImported = $sxe->importNode($keepme, true);
$sxe->appendChild($tempImported);
$sxe->saveXML();

}




//Load in the XSLT which does the magic
$xsl = new DOMDocument;
$xsl->load('rdfatoical.xsl');

// Configure the transformer

$style = $xsl->firstChild;
$source = $xsl->createElementNS('http://www.w3.org/1999/XSL/Transform', 'xsl:param');
$sourceattr = $xsl->createAttribute('name');
$sourceattr2 = $xsl->createAttribute('select');
$sourceattr->value = 'Source';
$sourceattr2->value = "string('".$frag[0]."')";
$source->appendChild($sourceattr);
$source->appendChild($sourceattr2);
$style->appendChild($source);

$style2 = $xsl->firstChild;
$dtstamp = $xsl->createElementNS('http://www.w3.org/1999/XSL/Transform', 'xsl:param');
$dtattr = $xsl->createAttribute('name');
$dtattr2 = $xsl->createAttribute('select');
$dtattr->value = 'Stamp';
$dtattr2->value = "string('".date('Ymd\THis',time())."')";
$dtstamp->appendChild($dtattr);
$dtstamp->appendChild($dtattr2);
$style2->appendChild($dtstamp);
$xsl->saveXML();


$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);

$cal = $proc->transformToXML($sxe);

echo $cal;
?>
