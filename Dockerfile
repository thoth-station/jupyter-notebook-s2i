# Jupyter Notebook S2I builder image
FROM registry.access.redhat.com/ubi8/python-36

ENV SUMMARY="Jupyter Notebook s2i builder image." \
    DESCRIPTION="Jupyter Notebook s2i builder image. This toolchain is based on Red Hat UBI8. It includes pipenv."

LABEL summary="$SUMMARY" \
    description="$DESCRIPTION" \
    io.k8s.description="$DESCRIPTION" \
    io.k8s.display-name="Jupyter Notebook STI" \
    io.openshift.tags="builder,jupyter,notebook,python,python36" \
    name="jupyter-notebook-s2i:latest" \
    vendor="AICoE, Office of the CTO, Red Hat Inc." \
    version="0.1.0" \
    release="0" \
    maintainer="Marek Cermak <macermak@redhat.com>"

# Copy builder scripts
COPY ./s2i/bin/ /usr/libexec/s2i
COPY ./s2i/lib/ /usr/libexec/s2i-lib

# Install required packages and setup environment
USER 0

RUN curl \
    -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    -o /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    pip3 install pipenv==2018.11.26 ipython ipykernel papermill[s3]

RUN chown -R 1001:0 /usr/libexec/s2i /usr/libexec/s2i-lib && \
    chown -R 1001:0 ${APP_ROOT} && \
    fix-permissions ${APP_ROOT} -P

USER 1001
# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]