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

  # Install the openai module if it is not already installed
  if (!(Get-Module openai -ListAvailable)) {
    Install-Module openai
  }

  # Load the API key from a file in the current directory
  $apiKeyFile = Join-Path -Path (Get-Location) -ChildPath 'api-key.txt'
  $apiKey = Get-Content $apiKeyFile

  # Set the API key
  Set-OpenAIKey -Key $apiKey

  # Send the command description to chat GPT
  $response = Invoke-OpenAI -Model chat -Prompt $prompt

  # Parse the response and create a PowerShell function
  $function = [scriptblock]::Create($response)

  # Add the function to the PowerShell namespace
  Set-Item -Path "Function:$Alias" -Value $function
}

# Original prompt:
# write a powershell function that takes as input the description of a command and an alias
# and works as follows. It prompts chat gpt for a powershell function that implements that description,
# and it adds the returned function to the powershell namespace, executed by the given alias.

# Automatically add the phrase "write a powershell function that" to the prompt.
# Update this so it loads my api key from a file.
# load the key from the current directory.
