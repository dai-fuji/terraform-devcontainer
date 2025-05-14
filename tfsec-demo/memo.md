## インストール方法

```bash
sudo apt-get install wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

## 使い方

```
trivy config .
```

```
trivy config -f json -o trivy.json .
```

```
trivy config --tf-vars terraform.tfvars .
```

```
trivy conf . --ignorefile ./.trivyignore.yaml
```

ignore の方法
tfsec-demo/.trivyignore.yaml
ファイル単位での指定が可能

tfsec-demo/.trivyignore
特定の ID のを検出から除外

インラインコメント
