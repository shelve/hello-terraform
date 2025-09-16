# Terraform Configuration without Cloud Providers
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Variables
variable "greeting_message" {
  description = "Message to display in hello world output"
  type        = string
  default     = "Hello, World from Terraform!"
}

variable "shell_command" {
  description = "Shell command to execute"
  type        = string
  default     = "echo 'Hello from shell command executed by Terraform!'"
}

variable "output_file_name" {
  description = "Name of the output file to create"
  type        = string
  default     = "terraform-output.txt"
}

# Local file resource - creates a file with content
resource "local_file" "hello_world_file" {
  filename = var.output_file_name
  content  = <<-EOT
    ${var.greeting_message}
    
    This file was created by Terraform without using any cloud providers.
    Timestamp: ${timestamp()}
    
    Terraform maintains state for this local file operation.
  EOT
}

# Null resource to execute shell commands
resource "null_resource" "hello_shell_command" {
  # This will run every time due to the timestamp trigger
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = var.shell_command
  }

  # Depends on the file being created first
  depends_on = [local_file.hello_world_file]
}

# Another shell command example - list current directory
resource "null_resource" "list_directory" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Current directory contents:' && ls -la"
  }

  depends_on = [null_resource.hello_shell_command]
}

# Outputs
output "greeting_message" {
  description = "The hello world message"
  value       = var.greeting_message
}

output "created_file_path" {
  description = "Path to the created file"
  value       = local_file.hello_world_file.filename
}

output "file_content_md5" {
  description = "MD5 hash of the created file content"
  value       = local_file.hello_world_file.content_md5
}

output "executed_command" {
  description = "The shell command that was executed"
  value       = var.shell_command
}

output "timestamp" {
  description = "Timestamp when resources were created"
  value       = timestamp()
}
