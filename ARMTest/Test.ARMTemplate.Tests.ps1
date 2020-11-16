#Pester tests
Describe 'ARM Template Validation' {
  Context "Template Syntax" { 
    It "Has a JSON template" { 
      "$demoPath\VM.Temp.json" | Should Exist 
    } 

    It "Has a parameters file" { 
      "$demoPath\VM.Parameter.json" | Should Exist 
    } 
  }

  Context "JSON Properties" { 
    It "Converts from JSON and has the expected properties" { 
      $expectedProperties = '$schema', 'contentVersion', 'parameters', 'variables', 'resources', 'outputs' 
      $templateProperties = (get-content "$demoPath\VM.Temp.json" | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | % Name
      $templateProperties | Should Be $expectedProperties 
    }
  }

  Context "Azure resources" { 
    It "Creates the expected Azure resources" { 
      $expectedResources = 'Microsoft.Network/networkInterfaces', 'Microsoft.Network/networkSecurityGroups', 'Microsoft.Network/virtualNetworks', 'Microsoft.Network/publicIpAddresses', 'Microsoft.Compute/virtualMachines'
      $templateResources = (get-content "$demoPath\VM.Temp.json" | ConvertFrom-Json -ErrorAction SilentlyContinue).Resources.type  | Should Be $expectedResources 
    }
  }	
	
  Context 'Template Content Validation' {
    It "Contains all required elements" {
      $bValidRequiredElements = $true
      Foreach ($item in $requiredElements) {
        if (-not $TemplateElements.Contains($item)) {
          $bValidRequiredElements = $false
          Write-Output "template does not contain '$item'"
        }
      }
      $bValidRequiredElements | Should be $true
    }

    It "Only contains valid elements" {
      $bValidElements = $true
      Foreach ($item in $TemplateElements) {
        if ((-not $requiredElements.Contains($item)) -and (-not $optionalElements.Contains($item))) {
          $bValidElements = $false
        }
      }
      $bValidElements | Should be $true
    }
    
    If ($bCheckParameters -eq $true) {
      It "Only has approved parameters" {
        $parametersFromTemplateFile = $TemplateJson.parameters.psobject.Properties.name | Sort-Object
        $strParametersFromTemplateFile = $parametersFromTemplateFile -join ','
        $parameters = $parameters | Sort-Object
        $strParameters = $parameters -join ','
        $strParametersFromTemplateFile | Should be $strParameters
      }
    }

    if ($bCheckVariables) {
      It "Only has approved variables" {
        $variablesFromTemplateFile = $TemplateJson.variables.psobject.Properties.name | Sort-Object
        $variables = $variables | Sort-Object
        $strVariablesFromTemplate = $variablesFromTemplateFile -join ','
        $strVariables = $variables -join ','
        $strVariablesFromTemplate | Should be $strVariables
      }
    }
    
    if ($bCheckFunctions) {
      It "Only has approved functions" {
        #parse functions from the template file
        $arrFunctionsFromTemplateFile = @()
        Foreach ($item in $TemplateJson.functions) {
          foreach ($member in $item.members.psobject.Properties.name) {
            $arrFunctionsFromTemplateFile += "$($item.namespace).$member"
          }
        }
        $arrFunctionsFromTemplateFile = $arrFunctionsFromTemplateFile | Sort-Object
        $strFunctionsFromTemplateFile = $arrFunctionsFromTemplateFile -join ','

        #parse input parameter functions
        $arrApprovedFunctions = $functions | Sort-Object
        $strApprovedFunctions = $arrApprovedFunctions -join ","
        $strFunctionsFromTemplateFile | Should be $strApprovedFunctions
      }
    }

    It "Only has approved resources" {
      $resourcesFromTemplate = $TemplateJson.resources.type | Sort-Object
      $strResourcesFromTemplate = $resourcesFromTemplate -join ','
      $resources = $resources | Sort-Object
      $strResources = $resources -join ','
      $strResourcesFromTemplate | Should be $strResources
    }

    If ($bCheckOutputs) {
      It "Only has approved outputs" {
        $outputsFromTemplate = $TemplateJson.outputs.psobject.Properties.name | Sort-Object
        $strOutputsFromTemplate = $outputsFromTemplate -join ','
        $outputs = $outputs | Sort-Object
        $strOutputs = $outputs -join ','
        $strOutputsFromTemplate | Should be $strOutputs
      }
    }
  }
}

#Done