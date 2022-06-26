DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${DIR}"
helm template simple-bank ../../ -f values.yaml > final.yaml