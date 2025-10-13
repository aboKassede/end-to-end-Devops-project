################################################################
#################### Jenkins Security Group ###################
################################################################
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Jenkins Security Group"
  tags        = var.tags
}

# GitHub Webhooks IPv4
resource "aws_security_group_rule" "jenkins_github_ipv4" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins-sg.id
  cidr_blocks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
    var.myIp
  ]
}

# GitHub Webhooks IPv6
resource "aws_security_group_rule" "jenkins_github_ipv6" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins-sg.id
  ipv6_cidr_blocks  = ["2a0a:a440::/29", "2606:50c0::/32"]
}

# Allow SonarQube → Jenkins
resource "aws_security_group_rule" "sonar_to_jenkins" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-sg.id
  source_security_group_id = aws_security_group.sonarqube-sg.id
}

# SSH access to Jenkins from your IP
resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins-sg.id
  cidr_blocks       = [var.myIp]
}

# Egress - allow all
resource "aws_security_group_rule" "jenkins_egress_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "jenkins_egress_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

################################################################
#################### SonarQube Security Group ##################
################################################################
resource "aws_security_group" "sonarqube-sg" {
  name        = "sonarqube-sg"
  description = "SonarQube Security Group"
  tags        = var.tags
}

# Allow Jenkins → SonarQube
resource "aws_security_group_rule" "jenkins_to_sonar" {
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sonarqube-sg.id
  source_security_group_id = aws_security_group.jenkins-sg.id
}

# SSH access to SonarQube from your IP
resource "aws_security_group_rule" "sonar_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sonarqube-sg.id
  cidr_blocks       = [var.myIp]
}

# Access to SonarQube UI from your IP
resource "aws_security_group_rule" "sonar_ui" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp"
  security_group_id = aws_security_group.sonarqube-sg.id
  cidr_blocks       = [var.myIp]
}

# Egress - allow all
resource "aws_security_group_rule" "sonar_egress_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sonarqube-sg.id
}

resource "aws_security_group_rule" "sonar_egress_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sonarqube-sg.id
}

################################################################
#################### Nexus Security Group ######################
################################################################
resource "aws_security_group" "nexus-sg" {
  name        = "nexus-sg"
  description = "Nexus Security Group"
  tags        = var.tags
}

# Allow Jenkins → Nexus
resource "aws_security_group_rule" "jenkins_to_nexus" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nexus-sg.id
  source_security_group_id = aws_security_group.jenkins-sg.id
}

# SSH access to Nexus from your IP
resource "aws_security_group_rule" "nexus_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nexus-sg.id
  cidr_blocks       = [var.myIp]
}

# Access to Nexus UI from your IP
resource "aws_security_group_rule" "nexus_ui" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  security_group_id = aws_security_group.nexus-sg.id
  cidr_blocks       = [var.myIp]
}

# Egress - allow all
resource "aws_security_group_rule" "nexus_egress_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nexus-sg.id
}

resource "aws_security_group_rule" "nexus_egress_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.nexus-sg.id
}
