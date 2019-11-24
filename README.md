# jupyter-notebook-s2i
[![Docker Repository on Quay](https://quay.io/repository/cermakm/jupyter-notebook-s2i/status "Docker Repository on Quay")](https://quay.io/repository/cermakm/jupyter-notebook-s2i)

Jupyter notebook s2i builder image.

## Test

To test that everything works properly, run `make test`

## Usage

```bash
IMAGE_NAME="jupyter-notebook-s2i"

s2i build \
    --env JUPYTER_NOTEBOOK_PATH='test-notebook.ipynb' \
    'test/s2i/test-app/' quay.io/cermakm/jupyter-notebook-s2i ${IMAGE_NAME}
```

> NOTE: Path to the notebook is relative to the `$APP_ROOT` directive and is resolved *during container runtime*.

`docker run` will then execute the notebook inside the container:

```bash
CONTAINER_NAME="notebook_container"
docker run -it \
    --env JUPYTER_NOTEBOOK_PATH='test-notebook.ipynb' \
    --name "$CONTAINER_NAME"
    ${IMAGE_NAME}:latest
```

To explore the output notebook, you can copy it out of the container:

```bash
docker cp "$CONTAINER_NAME":'/opt/app-root/src/output.ipynb' /tmp/output.ipynb

cat /tmp/output.ipynb | jq -r '.metadata.papermill'
```

## Parametrization

TBD
