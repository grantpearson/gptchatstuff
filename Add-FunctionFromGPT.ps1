function Add-FunctionFromGPT {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string] $Description,
    [Parameter(Mandatory=$true)]
    [string] $Alias
  )

  # Add the prompt prefix to the description
  $prompt = "write a PowerShell function that $Description"

  # Load the API key from a file in the current directory
  $apiKeyFile = Join-Path -Path (Get-Location) -ChildPath 'api-key.txt'
  $apiKey = Get-Content $apiKeyFile

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
    'model' = 'text-davinci-002'
    'context' = @'write a powershell function that takes as input the description of a command and an alias and works as follows. It prompts chat gpt for a powershell function that implements that description and it adds the returned function to the powershell namespace, executed by the given alias.'@
  }
  $jsonData = $data | ConvertTo-Json

  # Send the HTTP POST request to the OpenAI API
  $response = Invoke-WebRequest -Method Post -Uri 'https://api.openai.com/v1/completions' -Headers $headers -Body $jsonData

  # Parse the response and create a PowerShell function
  $function = ($response.Content | ConvertFrom-Json).choices[0].text
  $function = [scriptblock]::Create($function)

  # Add the function to the PowerShell namespace
  Set-Item -Path "Function:$Alias" -Value $function
}

# Original prompt:
# write a powershell function that takes as input the description of a command and an alias
# and works as follows. It prompts chat gpt for a powershell function that implements that description
# and it adds the returned function to the powershell namespace, executed by the given alias.
