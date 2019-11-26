# Common functionality

# Kernel to be used to execute the notebook
export JUPYTER_NOTEBOOK_KERNEL="${JUPYTER_NOTEBOOK_KERNEL:-python3}"

# Papermill configuration
export PAPERMILL_OUTPUT_PATH="${PAPERMILL_OUTPUT_PATH:-"/mnt/artifacts/outputs/notebook.ipynb"}"

# Output directory for models, checkpoints, etc...
export MODEL_OUTPUT_DIR="${MODEL_OUTPUT_DIR:-"/mnt/artifacts/models"}"

die() {
	>&2 echo -e "$1"
	exit 1
}
