#Policy resource
resource "aws_iam_role" "EC2-Start-Stop-Role" {
  name = "EC2-Start-Stop-Role"
  assume_role_policy = "${file("./IAM/lambda_allow.json.tpl")}"
  inline_policy {
    name = "ec2-start-stop"

    policy = "${file("./IAM/ec2allow.json.tpl")}"
  }
  tags = {
    tag-key = "tag-value"
  }
}
