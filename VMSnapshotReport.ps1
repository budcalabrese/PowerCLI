##### PowerCLI Awesome Snapshot Report tool ######

# Used to create our HTML output table with CSS
$Head = @"
<style>
body { background-color:#f6f6f6; font-family:calibri; margin:0px;}
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #34495e; color:#ffffff}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
TR:Nth-Child(Even) {Background-Color: #dddddd;}
</style>
"@

# Gets snapshot info and reports out the details
$Report = Get-VM | Get-Snapshot | Select VM,Name,Description,@{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}},Created

# Converts the output to HTML and save it to c:\temp
$Report | ConvertTo-Html -Head $Head -PreContent "<p><h2> Snapshot Report </h2></p><br>" | Out-File "C:\temp\SnapShotReport.html"
