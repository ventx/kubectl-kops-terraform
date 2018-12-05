FROM ventx/alpine

ENV TERRAFORM_VERSION 0.11.8
ENV KOPS_VERSION 1.10.0
ENV KUBECTL_VERSION v1.10.11

RUN apk --update --no-cache add libc6-compat git openssh-client python py-pip && pip install awscli

RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 -o /usr/local/bin/kops && \
    chmod +x /usr/local/bin/kops

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

WORKDIR /work

CMD ["/bin/bash", "-l"]
