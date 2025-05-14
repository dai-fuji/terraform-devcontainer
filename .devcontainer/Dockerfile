ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-${VARIANT}

# Install OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    make

# Install trivy
RUN wget apt-transport-https gnupg \
    && wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | tee -a /etc/apt/sources.list.d/trivy.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends trivy

USER vscode

ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TFSEC_VERSION=1.15.2
ARG TERRASCAN_VERSION=1.13.2
ARG TFLINT_AWS_RULESET_VERSION=0.21.1

RUN cd /tmp/ \
    && git clone https://github.com/awslabs/aws-code-habits.git \
    && cd aws-code-habits \
    && make devcontainer/terraform/init \
    && rm -rf /tmp/aws-code-habits

USER root

COPY post-start.sh /usr/local/bin/post-start
RUN chmod +x /usr/local/bin/post-start
