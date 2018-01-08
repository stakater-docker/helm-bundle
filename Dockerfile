FROM stakater/base-alpine:3.7

ARG GUID=2342
ARG USER=helm

ARG HELM_VERSION=v2.7.2
ARG HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_URL=http://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME}

ARG LANDSCAPER_VERSION=1.0.12
ARG LANDSCAPER_FILENAME=landscaper-${LANDSCAPER_VERSION}-linux-amd64.tar.gz
ARG LANDSCAPER_URL=https://github.com/Eneco/landscaper/releases/download/${LANDSCAPER_VERSION}/${LANDSCAPER_FILENAME}

ARG KUBECTL_VERSION=v1.9.1
ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

ENV HOME=/home/${USER}/

RUN curl -L ${HELM_URL} | tar zxv -C /tmp \
    && cp /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp/*

RUN curl -L ${LANDSCAPER_URL} | tar zxv -C /tmp \
    && cp /tmp/landscaper /bin/landscaper \
    && rm -rf /tmp/*

ADD ${KUBECTL_URL} /usr/local/bin/kubectl

RUN set -x && \
    chmod +x /usr/local/bin/kubectl \
    && adduser helm -Du ${GUID} -h ${HOME} \
    && kubectl version --client \
    && helm version --client \
    && landscaper version

USER ${USER}

# Remove this after generating kubeconfig via pipeline
COPY config ${HOME}.kube/config

ENTRYPOINT [ "" ]