local -a _git_commit_aliases
_git_commit_aliases=(
  'build'
  'chore'
  'ci'
  'docs'
  'feat'
  'fix'
  'perf'
  'refactor'
  'revert'
  'style'
  'test'
  'wip'
)

_git_commit_flags=(
  '-s'
  '--scope'
  '-a'
  '--attention'
  '-sa'
  '-as'
)

remove_flags() {
  local message="$1"
  local flags=("${@:2}")

  local regex=$(IFS="|"; echo "${_git_commit_flags[*]}")

  message=$(sed -E "s/\s($regex)\s|\s($regex)$//g" <<< "$message")

  echo "$message"
};

build_message () {
  if [[ "$*" =~ (-sa|-as) ]]; then
    local attention='!'
    local scope="($2)"
  elif [[ "$1" =~ (-a|--attention) ]]; then
    local attention='!'
  elif [[ "$2" =~ (-a|--attention) ]]; then
    local attention='!'
  elif [[ "$*" =~ (-a|--attention) ]]; then
    local attention='!'
  fi

  if [[ "$*" =~ (-s|--scope) ]]; then
    local scope="($2)"
  elif [[ "$2" =~ (-s|--scope) ]]; then
    local scope="($3)"
  fi

  local message="'$type'${scope}$attention: $@";

  git commit -m $(remove_flags "$message" "${_git_commit_flags[@]}")
};

local alias type
for type in "${_git_commit_aliases[@]}"; do
  # an alias can't be named "revert" because the git command takes precedence
  # https://stackoverflow.com/a/3538791
  case "$type" in
  revert) alias=rev ;;
  *) alias=$type ;;
  esac

  if ! git config --global --get-all alias.${alias} >/dev/null 2>&1; then
    git config --global alias.${alias} build_message
  fi
done

unset _git_commit_aliases _git_commit_flags alias type
