$sourceLocation = G:\rdnext\Azure\Compute\src
$sourceBranch = "master"
$destinationBranch = "core"

function Send-Mail {
    param(
     [Parameter(Mandatory=$true)]
     [String[]] $to,
     $commitDetails)

    send-mailmessage `
        -from "zanygnu@zanygnu.com" `
        -t $to  `
        -cC zanygnu@zanygnu.com `
        -BodyAsHtml `
        -subject "Merge request: '$($sourceBranch)' needs to be merged into $($destinationBranch)" `
        -body "$commitDetails" `
        -smtpServer smtphost
} 


pushd $sourceLocation

$missingCommitDetails = ""
$missingCommitDetails = ""

$htmlTemplate = '<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 15 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
    {font-family:"Cambria Math";
    panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
    {font-family:Calibri;
    panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
    {margin:0in;
    margin-bottom:.0001pt;
    font-size:12.0pt;
    font-family:"Times New Roman",serif;}
h1
    {mso-style-link:"Heading 1 Char";
    margin-top:12.0pt;
    margin-right:0in;
    margin-bottom:0in;
    margin-left:0in;
    margin-bottom:.0001pt;
    page-break-after:avoid;
    font-size:16.0pt;
    font-family:"Calibri Light",sans-serif;
    color:#2E74B5;
    font-weight:normal;}    
a:link, span.MsoHyperlink
    {color:#0563C1;
    text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
    {color:#954F72;
    text-decoration:underline;}
.MsoPapDefault
    {margin-bottom:8.0pt;
    line-height:107%;}
@page WordSection1
    {size:8.5in 11.0in;
    margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
    {page:WordSection1;}
-->
</style>

</head>

<body lang=EN-US link="#0563C1" vlink="#954F72">

<div class=WordSection1>

<h1>Branch '+ $destinationBranch + ' not up to date with ' + $sourceBranch + '</h1>

<p class=MsoNormal>&nbsp;</p>

<p class=MsoNormal><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">The
following commits have not been merged into the branch ' + $destinationBranch + '. Please
merge them as soon as possible. </span></p>

<p class=MsoNormal><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">This
email will be sent daily until this merge is complete.</span></p>

<p class=MsoNormal>&nbsp;</p>
<p class=MsoNormal>&nbsp;</p>

<table class=MsoTable15Plain5 border=0 cellspacing=0 cellpadding=0
 style="border-collapse:collapse">
 <tr>
  <td width=75 valign=top style="width:75.0pt;border:none;border-bottom:solid #7F7F7F 1.0pt;
  background:white;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal align=right style="text-align:right"><i><span
  style="font-size:10.0pt;font-family:''Calibri'',sans-serif">Commit</span></i></p>
  </td>
  <td width=50 valign=top style="width:50.0pt;border:none;border-bottom:solid #7F7F7F 1.0pt;
  background:white;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><i><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">Details</span></i></p>
  </td>
  <td width=150 valign=top style="width:150.0pt;border:none;border-bottom:solid #7F7F7F 1.0pt;
  background:white;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><i><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">&nbsp;</span></i></p>
  </td>
  <td width=300 valign=top style="width:300.0pt;border:none;border-bottom:solid #7F7F7F 1.0pt;
  background:white;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><i><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">&nbsp;</span></i></p>
  </td>
 </tr>
 %%COMMITS%%
</table>

<p class=MsoNormal><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">&nbsp;</span></p>

</div>

</body>

</html>'

$trTemplate = ' <tr>
  <td width=75 valign=top style="width:75.0pt;border:none;border-right:solid #7F7F7F 1.0pt;
  background:white;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal align=right style="text-align:right"><i><span
  style="font-size:10.0pt;font-family:''Calibri'',sans-serif">
  %%COMMIT_HASH%%
  </span></i></p>
  </td>
  <td width=50 valign=top style="width:50.0pt;background:#F2F2F2;padding:
  0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><span style="font-size:9.0pt;font-family:''Calibri'',sans-serif">
    %%COMMIT_AUTHOR%%
  </span></p>
  </td>
  <td width=150 valign=top style="width:150.0pt;background:#F2F2F2;padding:0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">
    %%COMMIT_DATE%%
  </span></p>
  </td>
  <td width=300 valign=top style="width:300.0pt;background:#F2F2F2;padding:
  0in 5.4pt 0in 5.4pt">
  <p class=MsoNormal><span style="font-size:10.0pt;font-family:''Calibri'',sans-serif">
    %%COMMIT_SUBJECT%%
  </span></p>
  </td>
 </tr>'

$index = 0;
while($true) {
    git log -n 1 --pretty=format:"%H" "origin/$($sourceBranch)~$($index)" | tee-object -Variable commitInMaster
    git branch -r --contains $commitInMaster | tee-object -Variable branchList
    $index++
    if (([string]$branchList).Contains("origin/$($destinationBranch)"))
    {
        Write-Host "commit exists in $($destinationBranch)"
        break;
    } 
    else 
    {
        git log -n 1 $commitInMaster | tee-object -Variable commitDetails

        git log --pretty=format:'%h' -n 1 $commitInMaster | tee-object -Variable commitHash
        git log --date=iso --pretty=format:'%ad' -n 1 $commitInMaster | tee-object -Variable commitDate
        git log --pretty=format:'%ae %an' -n 1 $commitInMaster | tee-object -Variable commitAuthor
        git log --pretty=format:'%s' -n 1 $commitInMaster | tee-object -Variable commitSubject
        $commitAuthor = $commitAuthor.Substring(0, $commitAuthor.IndexOf("@"))

        $tr = $trTemplate
        $tr = $tr.Replace("%%COMMIT_HASH%%", $commitHash)
        $tr = $tr.Replace("%%COMMIT_DATE%%", $commitDate)
        $tr = $tr.Replace("%%COMMIT_AUTHOR%%", $commitAuthor)
        $tr = $tr.Replace("%%COMMIT_SUBJECT%%", $commitSubject)

        # Skip checkins that were made by the build bot (corecet)
        if ($commitSubject.Contains("Incrementing build version to ") -and 
            $commitAuthor.Contains("corecet")) {
            continue;
        }

        $missingCommitDetails += $tr
    }
}

if ($missingCommitDetails -eq "") {
    Write-Host $destinationBranch is up to date.
} else { 
    Write-Host "$($destinationBranch) is missing a merge from $($sourceBranch)"
    $htmlTemplate = $htmlTemplate.Replace("%%COMMITS%%", $missingCommitDetails)
    Send-Mail -to zanygnu@zanygnu.com -commitDetails $htmlTemplate
}