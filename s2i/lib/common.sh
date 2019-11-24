# Common functionality

set -euxo

# Kernel to be used to execute the notebook
export JUPYTER_NOTEBOOK_KERNEL="${JUPYTER_NOTEBOOK_KERNEL:-python3}"

# Output directory for models, checkpoints, etc...
export MODEL_OUTPUT_DIR="/tmp/models"

die() {
	>&2 echo -e "$1"
	exit 1
}
