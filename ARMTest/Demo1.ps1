## region demo
$demoPath = 'C:\sandbox\ARM-pester-01\armtemp'

## JSON file we created
ise "$demoPath\VM.Temp.json"

## Pester test template created earlier
ise "$demoPath\InfrastuctureTests.ps1"

## Run the example Pester test reading JSON values
Invoke-Pester "$demoPath\InfrastuctureTests.ps1" -OutputFile "$demoPath\TestResults.xml"  -OutputFormat NUnitXml
ise '$demoPath\TestResults.xml'