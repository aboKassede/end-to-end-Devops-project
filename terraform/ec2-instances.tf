data "aws_ami" "Ubuntu22ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
////////////////////////////////////////////////////////////////////


resource "aws_instance" "nexus" {
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.ci-Jenkins-key.key_name
  tags                   = var.tags
  vpc_security_group_ids = [aws_security_group.nexus-sg.id]



  # Upload Nexus installation script
  provisioner "file" {
    content = templatefile("templates/nexus.tmpl", {
      # USERNAME="nexus",
      # PASSWORD="nexus123",
      # NEXUS_VERSION="3.84.0-03",
      # NEXUS_HOME="/opt/nexus",
      # SONATYPE_WORK="/opt/sonatype-work/nexus3"
    })
    destination = "/tmp/nexus.sh"
  }

  # Execute Nexus installation script
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install dos2unix", # if not installed
      "dos2unix /tmp/nexus.sh",
      "chmod +x /tmp/nexus.sh",
      "sudo /tmp/nexus.sh"
    ]
  }

  # Connection block for both provisioners
  connection {
    type        = "ssh"
    user        = "ubuntu"              # Use 'ec2-user' for Amazon Linux
    private_key = file(var.private_key) # Path to your PEM key
    host        = self.public_ip
  }

}



////////////////////////////////////////////////////////////////////

resource "aws_instance" "Jenkins" {
  ami           = data.aws_ami.Ubuntu22ami.id     
  instance_type = "t2.medium"
  key_name      = var.private_key           # Your SSH key
  tags = var.tags
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  provisioner "file" {
    content     = templatefile("templates/jenkins.tmpl",{})
    destination = "/tmp/jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install dos2unix", # if not installed
      "dos2unix /tmp/jenkins.sh",
      "chmod +x /tmp/jenkins.sh",
      "sudo /tmp/jenkins.sh"
    ]
  }
  connection {
      type        = "ssh"
      user        = "ubuntu"         # or "ec2-user" for Amazon Linux
      private_key = file(var.private_key)
      host        = self.public_ip
    }
}

# ////////////////////////////////////////////////////////////////////


resource "aws_instance" "sonarqube" {
  ami           = data.aws_ami.Ubuntu22ami.id     
  instance_type = "t2.medium"
  key_name      = var.private_key           # Your SSH key
  tags = var.tags
  vpc_security_group_ids = [aws_security_group.sonarqube-sg.id]

  provisioner "file" {
    content     = templatefile("templates/sonarqube.tmpl",{})
    destination = "/tmp/sonarqube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install dos2unix", # if not installed
      "dos2unix /tmp/sonarqube.sh",
      "chmod +x /tmp/sonarqube.sh",
      "sudo /tmp/sonarqube.sh"
    ]
  }
  connection {
      type        = "ssh"
      user        = "ubuntu"         # or "ec2-user" for Amazon Linux
      private_key = file(var.private_key)
      host        = self.public_ip
    }
}

