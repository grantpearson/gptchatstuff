function Add-FunctionFromGPT {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string] $Description,
    [Parameter(Mandatory=$true)]
    [string] $Name
  )

  # Add the prompt prefix to the description
  $prompt = "write a PowerShell function named $Name (in the global scope by appending global: to the function name) that $Description"

  # Get the function from GPT
  $functionCode = Get-FunctionFromGPT -Prompt $prompt

  # Try running the function code up to 5 times, fixing any errors that may occur
  $attempts = 0
  while($attempts -lt 5) {
      try {
          # Create a new function with the generated function code
          Invoke-Expression $functionCode

          # Output the generated function code
          Write-Output $functionCode

          # Return the function code if no errors occurred
          return $functionCode
      }
      catch {
          # Increment the number of attempts
          $attempts++

          # If this is the last attempt, pass the function code and the error message to GPT to generate a fixed version of the function
          if ($attempts -eq 5) {
              # Set the prompt for GPT to fix the function
              $prompt = "fix the following PowerShell function: $functionCode
                         error: $($_.Exception.Message)"

              # Get the fixed function from GPT
              $fixedFunctionCode = Get-FunctionFromGPT -Prompt $prompt

              # Create a new function with the fixed function code
              Invoke-Expression $fixedFunctionCode

              # Output the fixed function code
              Write-Output $fixedFunctionCode

              # Return the fixed function code
              return $fixedFunctionCode
          }
      }
  }
}
