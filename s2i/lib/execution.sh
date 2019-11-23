# Jupyter notebook execution

source "common.sh"

# Execute Jupyter Notebook via Papermill
#
# env:
#   [required] JUPYTER_NOTEBOOK_PATH: path to the notebook
notebook::execution::run() {
	: "${JUPYTER_NOTEBOOK_PATH?Must set JUPYTER_NOTEBOOK_PATH environment variable}"

	[ ! -f "$JUPYTER_NOTEBOOK_PATH" ] && die "File $JUPYTER_NOTEBOOK_PATH not found."

    local output_notebook="$(dirname $JUPYTER_NOTEBOOK_PATH)/_output.ipynb"

    papermill "$JUPYTER_NOTEBOOK_PATH" "$output_notebook" \
        -p model_dir="$MODEL_OUTPUT_DIR" \
        --kernel "$JUPYTER_NOTEBOOK_KERNEL" \
        --report-mode \
        --request-save-on-cell-execute
}
