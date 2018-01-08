FROM stakater/base-alpine:3.7 as build

RUN apk add --update --no-cache -t ca-certificates git deps curl tar gzip

ARG HELM_VERSION=v2.7.2
ARG FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} | tar zxv -C /tmp

FROM stakater/base-alpine:3.7

ENV HOME=/home/helm/
ARG GUID=2342
ARG KUBECTL_VERSION=v1.9.1

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN set -x && \
    chmod +x /usr/local/bin/kubectl && \
    adduser helm -Du ${GUID} -h ${HOME} && \
    kubectl version --client

USER helm

COPY --from=build /tmp/linux-amd64/helm /bin/helm

# Remove this after generating kubeconfig via pipeline
COPY config ${HOME}.kube/config

ENTRYPOINT [ "" ]