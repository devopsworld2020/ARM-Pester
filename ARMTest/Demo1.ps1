## region demo
$demoPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

## Run the example Pester test reading JSON values
Invoke-Pester "$demoPath\Test.ARMTemplate.Tests.ps1" -OutputFile "$demoPath\TestResults.xml"  -OutputFormat NUnitXml
