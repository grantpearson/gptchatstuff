# Load an API key from a file in the current directory
function Load-ApiKey {
    [CmdletBinding()]
    param()
  
    $apiKeyFile = Join-Path -Path (Get-Location) -ChildPath 'api-key.txt'
    $apiKey = Get-Content $apiKeyFile
  
    return $apiKey
  }
  
  # Send an HTTP POST request to the OpenAI API to generate a PowerShell function
  function Get-FunctionFromGPT {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [string] $Prompt
    )
  
    # Load the API key from a file in the current directory
    $apiKey = Load-ApiKey
  
    # Set the headers for the HTTP request
    $headers = @{
      'Content-Type' = 'application/json'
      'Authorization' = "Bearer $apiKey"
    }
  
    # Set the data for the HTTP request
    $data = @{
      'prompt' = $prompt
      'max_tokens' = 1024
      'n' = 1
      'stop' = $null
      'temperature' = 0.5
      'model' = 'text-davinci-003'
    }
    $jsonData = $data | ConvertTo-Json
  
    # Send the HTTP POST request to the OpenAI API
    $response = Invoke-WebRequest -Method Post -Uri 'https://api.openai.com/v1/completions' -Headers $headers -Body $jsonData
  
    # Parse the response and create a PowerShell function
    $function = ($response.Content | ConvertFrom-Json).choices[0].text
   
    return $function
  }
  function Add-FunctionFromGPT {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [string] $Description,
      [Parameter(Mandatory=$true)]
      [string] $Name
    )
  
    # Add the prompt prefix to the description
    $prompt = "write a PowerShell function named (in the global scope by appending global: to the function name) $Name that $Description"
  
    # Get the function from GPT
    $functionCode = Get-FunctionFromGPT -Prompt $prompt
  
    # Create a new function with the generated function code
    Invoke-Expression $functionCode
  
    # Output the generated function code
    Write-Output $functionCode
  }
  