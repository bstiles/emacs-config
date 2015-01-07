#!/bin/bash
shopt -s extglob
set -o errexit
set -o nounset

here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=emacs-config

function abort {
    [ $# -gt 0 ] && echo "$*"
    exit 1
}

function display_help {
cat <<EOF
usage: $(basename "$0") machine-identifier

Sets up initialization files on a new machine. 'machine-identifier'
allows for identification of customization files unique to the machine
instance. Must contain only [-_0-9A-Za-z].

The initialization repository '$config_dir' must exist under
$HOME/.emacs.d/.

EOF
}

function abort_and_display_help {
    display_help && echo
    echo "-- ABORTED:"
    abort "$@"
}

[[ ${1-} = @(--help|-h) ]] && display_help && exit 0

[ -d "$HOME/.emacs.d/$config_dir" -a "$HOME/.emacs.d/init.el" ] \
    || abort_and_display_help "It appears that '$config_dir' isn't in the right location."

init_file="$HOME/.emacs.d/init.el"
machine=${1?Must specify machine-identifier}
machine_id_file="$HOME/.emacs.d/machine-identifier.el"

[[ $machine =~ ^[-_0-9A-Za-z]+$ ]] \
    || abort_and_display_help "Invalid machine-identifier."

echo "Linking/writing initialization files to $HOME/.emacs.d/..."

# Check first that we're in a clean state before writing anything
[ ! -e "$init_file" ] \
   || abort "ERROR: $init_file already exists"
[ ! -e "$machine_id_file" ] \
    || abort "ERROR: $machine_id_file already exists."

ln -s "$config_dir/init.el" "$init_file"
printf '(setq my-machine-identifier "%s")' "$machine" > "$machine_id_file"
