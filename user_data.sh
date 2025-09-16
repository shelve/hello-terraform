#!/bin/bash

# Update the system
yum update -y

# Install basic packages
yum install -y wget curl git

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create a simple index.html for testing
mkdir -p /var/www/html
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${project_name} - EC2 Instance</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
        .info { margin: 20px 0; padding: 15px; border-left: 4px solid #007cba; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 ${project_name}</h1>
            <p>EC2 Instance deployed with Terraform via HCP Terraform</p>
        </div>
        
        <div class="info">
            <h3>Instance Information:</h3>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>
            <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
        </div>
        
        <p>✅ This instance was successfully created using Terraform!</p>
    </div>
</body>
</html>
EOF

# Install and start a simple HTTP server (optional)
yum install -y httpd
systemctl start httpd
systemctl enable httpd
cp /var/www/html/index.html /var/www/html/

# Log completion
echo "User data script completed at $(date)" >> /var/log/user-data.log