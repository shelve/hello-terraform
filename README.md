# Hello Terraform (Cloud-Provider-Free)

A simple Terraform configuration that demonstrates state management without using any cloud providers.

## Features

- **No Cloud Dependencies**: Uses only local providers (`null` and `local`)
- **State Management**: Maintains Terraform state for all operations
- **Shell Command Execution**: Demonstrates running shell commands via Terraform
- **File Operations**: Creates and manages local files
- **Hello World Output**: Simple greeting and file creation example

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. View outputs:
   ```bash
   terraform output
   ```

## What it does

- Creates a local file `terraform-output.txt` with a hello world message
- Executes shell commands to display messages
- Lists directory contents
- Maintains state in `terraform.tfstate`
- Provides outputs showing file information and execution results

## Configuration

The configuration includes customizable variables:
- `greeting_message`: The hello world message (default: "Hello, World from Terraform!")
- `shell_command`: Shell command to execute (default: echo command)
- `output_file_name`: Name of the output file (default: "terraform-output.txt")
