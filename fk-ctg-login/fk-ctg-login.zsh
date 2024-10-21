#!/bin/bash
# step by step copy login password

MAX_STEP=6

function fk_ctg_login() {
    if [[ $# -lt 1 ]]; then
        echo  "Usage: fkctglog <step>"
        return 1
    fi

    if [[ -z ${CTG_LOGIN_PROFILE} ]]; then
        echo "error: could not find profile, please set CTG_LOGIN_PROFILE in zsh config."
        return 1
    fi

    for s in $(seq $2 ${MAX_STEP})
    do
        __is_step_not_set $1 $s
        # if no need max step, quit directory
        if [ $? -eq 1 ]; then
            echo "✅ done"
            break
        fi
        __echo_step_password $1 $s
        read
    done

}

function __is_step_not_set() {
    local region=$1
    local s=$2
    local step="@@$s"

    local input
    input=$(grep "$region" -A 16 "$CTG_LOGIN_PROFILE" | grep "$step" | awk -F \| '{printf "%s",$2}');
    echo "input: $input"
    if [ -z "$input" ]; then
        return 1
    fi
    return 0
}

function __echo_step_password() {
    local region=$1
    local s=$2
    local step="@@$s"

    local password

    password=$(grep "$region" -A 16 "$CTG_LOGIN_PROFILE" | grep "$step" | awk -F \| '{printf "%s",$2}')

    echo "✅ copy step $s password to clipboard. Press Enter to next step."
    echo -n $password | sed 's/\n//g' | pbcopy
}
