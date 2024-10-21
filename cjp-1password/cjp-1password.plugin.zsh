# Do nothing if op is not installled
(( ${+commands[op]})) || return

if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]]; then
  typeset -g -A _comps
  autoload -Uz _op
  _comps[op]=_op
fi

op completion zsh >| "$ZSH_CACHE_DIR/completions/_op" &|

# Load opswd function
autoload -Uz opswd
