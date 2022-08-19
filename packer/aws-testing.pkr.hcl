# VARIABLES
variable "aws_connection" {
  type = map(string)
}

variable "ansible_playbooks" {
  type = map(string)
}

variable "provisioningscripts" {
  type = list(string)
  default = []
}

# USER Variable : -var region=ap-southeast-2
variable "region" {
  type = string
  default = "ap-northeast-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
# To search the base image with aws cli
# aws ec2 describe-images --region 'ap-northeast-1'\
# 	--query 'reverse(sort_by(Images, &CreationDate))[0].[ImageId,CreationDate,Name]'\
#   --owner '099720109477'\
#   --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64*'\
#   --output table --profile YOURPROFILE
# aws ec2 describe-images --region 'ap-northeast-1'\
# 	--query 'reverse(sort_by(Images, &CreationDate))[0].[ImageId,CreationDate,Name]'\
#   --owner '099720109477'\
#   --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64*'\
#   --output table --profile YOURPROFILE

# aws ssm get-parameters --names \
# 	/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2 \
# 	/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
# 	/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-Base \
# 	/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-Base \
#		/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-Base \
# 	--query "Parameters[].[Value, LastModifiedDate, Name]" \
# 	--output table \
# 	--profile YOURPROFILE


source "amazon-ebs" "windowsserver2019-arcgisserver" {
  # AMI
  ami_name      = "arcgisserver-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2019"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisserver"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)

  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2019-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

source "amazon-ebs" "windowsserver2019-arcgisdatastore" {
  # AMI
  ami_name      = "arcgisdatastore-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2019"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisdatastore"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)

  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2019-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices 
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

source "amazon-ebs" "windowsserver2019-arcgisportal" {
  # AMI
  ami_name      = "arcgisportal-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2019"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisportal"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2019-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices 
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

source "amazon-ebs" "windowsserver2022-arcgisserver" {
  # AMI
  ami_name      = "arcgisserver-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2022"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisserver"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2022-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices 
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

source "amazon-ebs" "windowsserver2022-arcgisdatastore" {
  # AMI
  ami_name      = "arcgisdatastore-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2022"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisdatastore"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2022-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices 
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

source "amazon-ebs" "windowsserver2022-arcgisportal" {
  # AMI
  ami_name      = "arcgisportal-${local.timestamp}"
  region  = var.region
  instance_type = var.aws_connection.instance_type
  tags = {
    OS_Version = "Windows"
    OS_Release = "2022"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    AMI_ROLE = "arcgisportal"
    AMI_Release = "${local.timestamp}"
  }
  # Access (local. the aws configure action is used on github action)
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*","logs:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
  # Assume Role (local. the aws configure action is used on github action)
  # Polling
  aws_polling {
    delay_seconds = 30
    max_attempts = 120
  }
  # Run
  source_ami_filter {
    filters = {
      name             = "Windows_Server-2022-Japanese-Full-Base*"
      root-device-type = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
  communicator = var.aws_connection.win_communicator
  winrm_username = var.aws_connection.winrm_username
  user_data_file = var.aws_connection.user_data_file
  ssh_keypair_name = "aws-example-key"
  ssh_private_key_file = var.aws_connection.ssh_private_key_file
  # Session Manager
  # Block Devices
  # launch_block_device_mappings {
  #   device_name = "/dev/sda1"
  #   volume_size = 90
  #   volume_type = "gp2"
  #   delete_on_termination = true
  # }
  # ami_block_device_mappings {
  #   device_name = "xvdb"
  #   volume_size = 100
  #   volume_type = "gp2"
  #   delete_on_termination = true
  # }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 90
    volume_type = "gp2"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "xvdb"
    volume_size = 100
    volume_type = "gp2"
    delete_on_termination = true
  }
}

build {
  # to edit what you build image source(s)
  sources = [
    "source.amazon-ebs.windowsserver2022-arcgisdatastore"
  ]

  #########################################
  ### Control the variables file for target
  ### prepare the variables for arcgis server/portal for arcgis/arcgis datastore
  #########################################
  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisserver","amazon-ebs.windowsserver2019-arcgisserver"]
    playbook_file           = var.ansible_playbooks.arcgisserver_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false
  }

  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisportal","amazon-ebs.windowsserver2019-arcgisportal"]
    playbook_file           = var.ansible_playbooks.arcgisportal_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false
  }

  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisdatastore","amazon-ebs.windowsserver2019-arcgisdatastore"]
    playbook_file           = var.ansible_playbooks.arcgisdatastore_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false

    # "-vvv"
    # "--extra-vars",
    # "'ansible_winrm_read_timeout_sec=1000 ansible_winrm_operation_timeout_sec=900'"
  }

  provisioner "powershell" {
    only = ["amazon-ebs.windowsserver2022-arcgisserver","amazon-ebs.windowsserver2019-arcgisserver","amazon-ebs.windowsserver2022-arcgisdatastore","amazon-ebs.windowsserver2019-arcgisdatastore","amazon-ebs.windowsserver2022-arcgisportal","amazon-ebs.windowsserver2019-arcgisportal"]
    scripts = [var.provisioningscripts[0]]
  }
}

build {
  name = "dev"
  source "amazon-ebs.windowsserver2022-arcgisserver" {
    name = "amazon-ebs.windowsserver2022-arcgisserver-dev"
    launch_block_device_mappings {
      device_name = "/dev/sda1"
      volume_size = 120
      volume_type = "gp2"
      delete_on_termination = true
    }
  }
  source "amazon-ebs.windowsserver2022-arcgisdatastore" {
    name = "amazon-ebs.windowsserver2022-arcgisdatastore-dev"
    launch_block_device_mappings {
      device_name = "/dev/sda1"
      volume_size = 120
      volume_type = "gp2"
      delete_on_termination = true
    }
  }
  source "amazon-ebs.windowsserver2022-arcgisportal" {
    name = "amazon-ebs.windowsserver2022-arcgisportal-dev"
    launch_block_device_mappings {
      device_name = "/dev/sda1"
      volume_size = 120
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisserver-dev","amazon-ebs.windowsserver2019-arcgisserver-dev"]
    playbook_file           = var.ansible_playbooks.arcgisserver_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false
  }

  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisportal-dev","amazon-ebs.windowsserver2019-arcgisportal-dev"]
    playbook_file           = var.ansible_playbooks.arcgisportal_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false
  }

  provisioner "ansible" {
    only = ["amazon-ebs.windowsserver2022-arcgisdatastore-dev","amazon-ebs.windowsserver2019-arcgisdatastore-dev"]
    playbook_file           = var.ansible_playbooks.arcgisdatastore_playbook_file
    user                    = var.aws_connection.winrm_username
    ansible_env_vars    = [
        "ANSIBLE_HOST_KEY_CHECKING=False",
        "ANSIBLE_NOCOLOR=True",
        "ANSIBLE_DEBUG=0"
    ]
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=C:\\Python39\\bin'"
    ]
    use_proxy               = false

    # "-vvv"
    # "--extra-vars",
    # "'ansible_winrm_read_timeout_sec=1000 ansible_winrm_operation_timeout_sec=900'"
  }

  provisioner "powershell" {
    only = ["amazon-ebs.windowsserver2022-arcgisserver","amazon-ebs.windowsserver2019-arcgisserver","amazon-ebs.windowsserver2022-arcgisdatastore","amazon-ebs.windowsserver2019-arcgisdatastore","amazon-ebs.windowsserver2022-arcgisportal","amazon-ebs.windowsserver2019-arcgisportal"]
    scripts = [var.provisioningscripts[0]]
  }
}