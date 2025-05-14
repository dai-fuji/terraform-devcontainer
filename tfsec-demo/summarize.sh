#!/bin/bash

# 入力ファイルと出力ファイルのパス
INPUT_FILE="tfsec-demo/trivy.json"
OUTPUT_FILE="tfsec-demo/aws_related_misconfigurations.json"

# jq を使用して AVDID に "AWS" を含むオブジェクトを抽出
jq '.Results[] | select(.Misconfigurations != null) | .Misconfigurations[] | select(.AVDID | contains("AWS"))' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Extracted objects saved to $OUTPUT_FILE"
