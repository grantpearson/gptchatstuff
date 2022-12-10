


function Add-FunctionFromGPT {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string] $Description,
    [Parameter(Mandatory=$true)]
    [string] $Alias
  )

  # Install the openai module if it is not already installed
  if (!(Get-Module openai -ListAvailable)) {
    Install-Module openai
  }

  # Set the API key
  $apiKey = 'your-api-key'
  Set-OpenAIKey -Key $apiKey

  # Send the command description to chat GPT
  $response = Invoke-OpenAI -Model chat -Prompt $Description

  # Parse the response and create a PowerShell function
  $function = [scriptblock]::Create($response)

  # Add the function to the PowerShell namespace
  Set-Item -Path "Function:$Alias" -Value $function
}