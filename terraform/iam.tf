data "aws_iam_policy_document" "rackula_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "rackula" {
  name               = "tf4-rackula-role"
  assume_role_policy = data.aws_iam_policy_document.rackula_assume_role.json
}

resource "aws_iam_role_policy_attachment" "rackula_ssm" {
  role       = aws_iam_role.rackula.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "rackula" {
  name = "tf4-rackula-profile"
  role = aws_iam_role.rackula.name
}