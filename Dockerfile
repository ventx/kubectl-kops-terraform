FROM ventx/alpine

ENV ANSIBLELINT_VERSION 3.5.1
ENV TERRAFORM_VERSION 0.11.8
ENV KOPS_VERSION 1.10.0
ENV KUBECTL_VERSION v1.10.11

RUN apk --update --no-cache add \
    libc6-compat \
    git \
    python3 && \
    easy_install-3.6 pip && \
    pip install awscli && \
    apk add --no-cache --virtual .build-deps \
    make \
    gcc \
    libc-dev \
    openssl-dev \
    python3-dev \
    libffi-dev \
    && pip install ansible-lint==${ANSIBLELINT_VERSION} \
    && runDeps="$( \
      scanelf --needed --nobanner --recursive /usr/local \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
    )" \
    && apk add --no-cache --virtual .ansible-lint-rundeps $runDeps \
    && apk del .build-deps \
    && rm -rf ~/.cache/

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
