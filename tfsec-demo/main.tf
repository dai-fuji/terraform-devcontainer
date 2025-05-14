provider "aws" {
  region = "us-west-2"
}

# 脆弱なS3バケット - パブリックアクセス許可の問題
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-vulnerable-bucket"
  acl    = "public-read"  # tfsecで検出される脆弱性: パブリックアクセスが可能
}

# 暗号化されていないS3バケット
resource "aws_s3_bucket" "unencrypted_bucket" {
  bucket = "my-unencrypted-bucket"
  # 暗号化設定がない - tfsecで検出される脆弱性
}

# セキュリティグループの問題 - すべての送信元IPからのアクセスを許可
resource "aws_security_group" "wide_open_sg" {
  name        = "wide-open-security-group"
  description = "Security group with too permissive rules"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # tfsecで検出される脆弱性: すべてのIPからSSHを許可
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # tfsecで検出される脆弱性: すべてのIPからRDPを許可
  }
}

# 暗号化されていないRDSインスタンス
resource "aws_db_instance" "unencrypted_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "password123"  # tfsecで検出される脆弱性: ハードコードされたパスワード
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true  # tfsecで検出される脆弱性: パブリックアクセスが可能
  storage_encrypted    = false  # tfsecで検出される脆弱性: 暗号化が無効
}

# CloudTrail logging - 暗号化なし
resource "aws_cloudtrail" "unencrypted_trail" {
  name                          = "unencrypted-trail"
  s3_bucket_name                = aws_s3_bucket.unencrypted_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = false  # tfsecで検出される脆弱性: マルチリージョン設定なし
  enable_logging                = true
  # KMS暗号化が指定されていない - tfsecで検出される脆弱性
}

# IAMポリシーの問題 - 過度に寛容なポリシー
resource "aws_iam_policy" "overly_permissive_policy" {
  name        = "overly-permissive-policy"
  description = "A policy with too many permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  # tfsecで検出される脆弱性: 過度に寛容なポリシー（全ての操作を許可）
}

# 脆弱なEC2インスタンス
resource "aws_instance" "vulnerable_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = false  # tfsecで検出される脆弱性: 暗号化されていないディスク
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"  # tfsecで検出される脆弱性: IMDSv2が強制されていない
  }
}
