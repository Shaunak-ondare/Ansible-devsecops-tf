# AMIs
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"] # Amazon
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

# Key Pair
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key
}

# Security Groups
resource "aws_security_group" "linux_sg" {
  name        = "${var.project_name}-linux-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "windows_sg" {
  name        = "${var.project_name}-windows-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Linux Instance
resource "aws_instance" "linux_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.linux_sg.id]

  tags = {
    Name = "${var.project_name}-linux"
  }
}

# Windows Instance
resource "aws_instance" "windows_host" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.windows_sg.id]

  user_data = <<EOF
<powershell>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Method 1: Net User
net user Administrator "${var.windows_password}"
# Method 2: PowerShell Set-LocalUser
$SecurePassword = ConvertTo-SecureString "${var.windows_password}" -AsPlainText -Force
Set-LocalUser -Name "Administrator" -Password $SecurePassword
# Method 3: ADSI (Old school but unbreakable)
$admin = [adsi]"WinNT://./Administrator,user"
$admin.SetPassword("${var.windows_password}")
$admin.SetInfo()

$url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file
</powershell>
EOF

  tags = {
    Name = "${var.project_name}-windows"
  }
}
