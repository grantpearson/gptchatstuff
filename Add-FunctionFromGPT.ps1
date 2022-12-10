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

# Original prompt:
# write a powershell function that takes as input the description of a command and an alias
# and works as follows. It prompts chat gpt for a powershell function that implements that description,
# and it adds the returned function to the powershell namespace, executed by the given alias.
