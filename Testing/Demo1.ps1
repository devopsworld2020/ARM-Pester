## region demo
$demoPath = 'C:\Users\Pratap\Downloads\Demos-master\Testing'

## JSON file we created
ise "$demoPath\azuredeploy.json"

## Pester test template created earlier
ise "$demoPath\InfrastructureTests.ps1"

## Run the example Pester test reading JSON values
Invoke-Pester "$demoPath\InfrastructureTests.ps1" -OutputFile "$demoPath\TestResults.xml"  -OutputFormat NUnitXml
ise '$demoPath\TestResults.xml'