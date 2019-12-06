# Jupyter Notebook requirements management

_cleanup() {
	return 0
}

# Get notebook requirements
#
# args:
#   $1: path to the notebook
# yields: space-separated list of <package><constraint>
notebook::requirements::get() {
	local notebook="$1"

	if [ "$( cat "$notebook" | jq -c '.metadata.requirements' )" == "null" ]; then
		echo ""; return 0
	fi

	local requirements=$(
		cat "$notebook" | \
		jq -c '.metadata.requirements | { "dev-packages" } * { packages } | add | to_entries' |\
		jq -c '.[]' \
	)

	local packages=""
	for r in ${requirements}; do
		package=$(echo "$r" | jq -r '.key')
		version=$(echo "$r" | jq -r '.value')

		if [ "$version" == '*' ]; then
			packages=$(echo "$packages" "$package")
		else
			packages=$(echo "$packages" "$package$version")
		fi
	done

	echo ${packages}; return 0
}

# Install notebook requirements
#
# env:
#   [required] JUPYTER_NOTEBOOK_PATH: path to the notebook
notebook::requirements::install() {
	: "${JUPYTER_NOTEBOOK_PATH?Must set JUPYTER_NOTEBOOK_PATH environment variable}"

	if [ ! -f "$JUPYTER_NOTEBOOK_PATH" ] || [ "$(cat "$JUPYTER_NOTEBOOK_PATH")" == "" ]
	then
		die "File $JUPYTER_NOTEBOOK_PATH NOT found."
	fi

	echo "--- Installing notebook requirements"

	local requirements=$(notebook::requirements::get "$JUPYTER_NOTEBOOK_PATH")
	if [ -z "$requirements" ]; then
		>&2 echo -e "Notebook doesn't have any requirements. Skipping installation."
		return 0
	else
		echo -e "Required packages: ${requirements}"""
		pipenv install --verbose ${requirements}
	fi

	_cleanup
}
