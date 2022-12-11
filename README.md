# OpenAI PowerShell Function Generator

This repository contains a set of PowerShell functions for generating PowerShell functions using the [OpenAI API](https://beta.openai.com/docs/api-reference/completions/create).

## Requirements

- A [OpenAI API key](https://beta.openai.com/docs/getting-started/authentication)
- PowerShell 5.0 or later

## Installation

To use the function generator, clone this repository and place your OpenAI API key in a file named `api-key.txt` in the root directory of the repository.

## Usage

To generate a new function, use the `Add-FunctionFromGPT` function and provide a description of the function you want to create and a name for the function:

```powershell
Add-FunctionFromGPT -Description "determines whether a number is prime" -Name "Is-Prime"
```

This will generate a new function named Is-Prime in the global scope, which can be called like any other PowerShell function:

```powershell
Is-Prime 5
```
The Add-FunctionFromGPT function also outputs the generated function code to the console, so you can see how the function was created.

##Limitations

The generated functions are created using the text-davinci-002 model, which is optimized for natural language generation. As such, the generated functions may not always be syntactically correct or follow best practices for PowerShell development. Use the generated functions at your own risk.
