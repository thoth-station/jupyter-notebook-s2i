# Jupyter notebook execution

_cleanup() {
	return 0
}

# Prepare Jupyter Notebook for execution via Papermill
#
# args:
#   [required] $1: path to the notebook
notebook::execution::prep() {
	: "${1?Must provide path to the notebook}"

    local notebook="$1"

    echo "--- Preparing Jupyter notebook for execution."
    # install the new kernel with locked requirements
    # this assumes that we're running in the APP_ROOT
    # where the notebook requirements have been resolved
    pipenv run ipython kernel install --sys-prefix --name="$JUPYTER_NOTEBOOK_KERNEL"

    # replace notebook kernelspec to prevent usage of an invalid kernel
    if [ "$(cat "$JUPYTER_NOTEBOOK_PATH" | jq -c '.metadata.kernelspec')" != null ]; then
        cat "$JUPYTER_NOTEBOOK_PATH" |\
        jq -r '.metadata.kernelspec.display_name = env.JUPYTER_NOTEBOOK_KERNEL' |\
        jq -r '.metadata.kernelspec.name = env.JUPYTER_NOTEBOOK_KERNEL' \
        > /tmp/processed.ipynb

        mv /tmp/processed.ipynb "$JUPYTER_NOTEBOOK_PATH"
    fi

    echo "--- Success."; return 0
}

# Execute Jupyter Notebook via Papermill
#
# env:
#   [required] JUPYTER_NOTEBOOK_PATH: path to the notebook
notebook::execution::run() {
	: "${JUPYTER_NOTEBOOK_PATH?Must set JUPYTER_NOTEBOOK_PATH environment variable}"

	[ ! -f "$JUPYTER_NOTEBOOK_PATH" ] && die "File $JUPYTER_NOTEBOOK_PATH NOT found."

    local output_notebook="$(dirname $JUPYTER_NOTEBOOK_PATH)/output.ipynb"

    mkdir -p "$MODEL_OUTPUT_DIR"

    notebook::execution::prep "$JUPYTER_NOTEBOOK_PATH" || die "--- Notebook preparation FAILED"

    echo "--- Executing Jupyter notebook: $(basename "$JUPYTER_NOTEBOOK_PATH")"
    papermill \
        -p model_dir "$MODEL_OUTPUT_DIR" \
        --kernel "$JUPYTER_NOTEBOOK_KERNEL" \
        --report-mode \
        --request-save-on-cell-execute \
        "$JUPYTER_NOTEBOOK_PATH" "$output_notebook" || die "--- Notebook execution FAILED."
    echo "--- Success."; return 0
}
