# Account A: users and groups

resource "aws_iam_user" "engine" {
  name = "engine"
}

resource "aws_iam_user" "ci" {
  name = "ci"
}

resource "aws_iam_user" "developer_one" {
  name = "developer-one"
}

resource "aws_iam_user" "developer_two" {
  name = "developer-two"
}

resource "aws_iam_group" "group1" {
  name = "group1"
}

resource "aws_iam_group" "group2" {
  name = "group2"
}

resource "aws_iam_group_membership" "group1_members" {
  name  = "group1-members"
  group = aws_iam_group.group1.name

  users = [
    aws_iam_user.engine.name,
    aws_iam_user.ci.name
  ]
}

resource "aws_iam_group_membership" "group2_members" {
  name  = "group2-members"
  group = aws_iam_group.group2.name

  users = [
    aws_iam_user.developer_one.name,
    aws_iam_user.developer_two.name
  ]
}


resource "aws_iam_access_key" "engine" {
  user = aws_iam_user.engine.name
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}

# roleA: AWS administrative access, explicitly excluding IAM actions.

data "aws_iam_policy_document" "role_a_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:root"]
    }
  }
}

resource "aws_iam_role" "roleA" {
  name               = "roleA"
  assume_role_policy = data.aws_iam_policy_document.role_a_assume.json
}

resource "aws_iam_role_policy_attachment" "role_a_admin" {
  role       = aws_iam_role.roleA.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy" "role_a_deny_iam" {
  name = "deny-iam-administration"
  role = aws_iam_role.roleA.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Deny"
      Action   = "iam:*"
      Resource = "*"
    }]
  })
}

# roleB: permission to assume only Account B's roleC.

data "aws_iam_policy_document" "role_b_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:root"]
    }
  }
}

resource "aws_iam_role" "roleB" {
  name               = "roleB"
  assume_role_policy = data.aws_iam_policy_document.role_b_assume.json
}

resource "aws_iam_role_policy" "role_b_assume_roleC" {
  name = "assume-roleC-only"
  role = aws_iam_role.roleB.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::${var.account_b_id}:role/roleC"
    }]
  })
}

# Console login profiles for group2 users

resource "aws_iam_user_login_profile" "developer_one" {
  user                    = aws_iam_user.developer_one.name
  pgp_key                 = var.console_pgp_key
  password_reset_required = true
}

resource "aws_iam_user_login_profile" "developer_two" {
  user                    = aws_iam_user.developer_two.name
  pgp_key                 = var.console_pgp_key
  password_reset_required = true
}

# Programmatic credentials for group2 users

resource "aws_iam_access_key" "developer_one" {
  user = aws_iam_user.developer_one.name
}

resource "aws_iam_access_key" "developer_two" {
  user = aws_iam_user.developer_two.name
}


resource "aws_iam_group_policy_attachment" "group2_admin" {
  group      = aws_iam_group.group2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
