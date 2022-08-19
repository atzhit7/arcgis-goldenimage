aws_connection = {
  # "region"        = "ap-northeast-1"
  # set with your preferred AWS region, e.g. ap-northeast-1 tokyo, ap-southeast-1 singapore, ap-southeast-2 sydney
  "instance_type" = "t3.large"
  # t2.micro, t2.large
  # for aws instance of Ubuntu, user is default ubuntu
  "user_data_file" = "../scripts/win_rm.txt"
  "win_communicator" = "winrm"
  "winrm_username" = "Administrator"
  "ssh_username"  = "ubuntu"
  "ssh_keypair_name" = "aws-example-key"
  "ssh_private_key_file" = "../ansible/privatekey"
}

ansible_playbooks = {
  "arcgisserver_playbook_file"  = "../ansible/arcgisserver.yaml"
  "arcgisportal_playbook_file"  = "../ansible/arcgisportal.yaml"
  "arcgisdatastore_playbook_file"  = "../ansible/arcgisdatastore.yaml"
}

provisioningscripts = [
  "../scripts/aws_windows_sysprep.ps1",
  "../scripts/aws_windows_sysprep_2019.ps1",
]