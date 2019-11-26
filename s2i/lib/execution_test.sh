#!/bin/bash
# Test suite for Jupyter Notebook s2i execution module

abspath() {
    {
        cd "$(dirname "$1")" ; echo "$PWD"
    }
}

__dirname="$(abspath "${BASH_SOURCE[0]}")"


REPO_ROOT="$(abspath ${__dirname}/../../../)"

export JUPYTER_NOTEBOOK_PATH="${REPO_ROOT}/test/s2i/test-app/test-notebook.ipynb"


test::notebook::execution::run() {
    echo "---> Testing notebook::execution::run"

    local tmpdir="$(mktemp -td 'jupyter-notebook-s2i-test-XXX')"

    export PAPERMILL_OUTPUT_PATH="${tmpdir}/output.ipynb"
    export MODEL_OUTPUT_DIR="${tmpdir}/artifacts"

    notebook::execution::run

    [ ! -f "$PAPERMILL_OUTPUT_PATH" ] \
        && die "Missing expected output notebook."
    [ "$(cat "$PAPERMILL_OUTPUT_PATH")" == "" ] \
        && die "Empty output notebook."
    [ "$(cat "$PAPERMILL_OUTPUT_PATH" | jq -c '.metadata.papermill')" == "" ] \
        && die "Missing Papermill metadata."
    [ "$(cat "$PAPERMILL_OUTPUT_PATH" | jq -c '.metadata.papermill.exception')" != "null" ] \
        && die "Unexpected exception occurred."

    echo "---> Success."
}

if [ "$0" = "$BASH_SOURCE" ] ; then
{
    set -eux
    pushd "${__dirname}"

    source "common.sh"
    source "execution.sh"

    test::notebook::execution::run
}
fi
