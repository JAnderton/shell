#!/bin/bash

function setup_colors()
{
    [[ -t 1 ]] || return
    local -r ncolors=$(tput colors)
    [[ -n "$ncolors" && $ncolors -ge 8 ]] || return
    pblack=$(tput setaf 0)
    pred=$(tput setaf 1)
    pgreen=$(tput setaf 2)
    pyellow=$(tput setaf 3)
    pblue=$(tput setaf 4)
    pmagenta=$(tput setaf 5)
    pcyan=$(tput setaf 6)
    pwhite=$(tput setaf 7)
    prev=$(tput rev)
    pbold=$(tput bold)
    preset=$(tput sgr0)
}

function setup_diff()
{
    if [[ -n $(which dwdiff 2>/dev/null) ]]
    then
        shopt -s expand_aliases
        if $color
        then
            alias diff='dwdiff -c -l -A best'
        else
            alias diff='dwdiff -A best'
        fi
    fi
}

function print_usage()
{
    cat <<EOU
Usage: $0 [-c|--color][-d|--debug]|[-q|--quiet] <script> [test_scripts]
EOU
}

function enable_debug()
{
    export debug=true
    export PS4='+${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): } '
    set -o pipefail
    set -o xtrace
    echo "$0: Called with $@"
}

color=false
quiet=false
while getopts :cdq-: opt
do
    [[ - == $opt ]] && opt=${OPTARG%%=*} OPTARG=${OPTARG#*=}
    case $opt in
    c | color ) color=true ; setup_colors ;;
    d | debug ) enable_debug "$@" ;;
    q | quiet ) quiet=true ;;
    * ) print_usage >&2 ; exit 3 ;;
    esac
done
shift $((OPTIND - 1))

case $# in
0 ) print_usage >&2 ; exit 3 ;;
* ) script=$1 ; shift ;;
esac

setup_diff

rootdir=$(dirname $0)

. $rootdir/test-functions.sh

scenarios=()
for t in "$@"
do
    if [[ -d "$t" ]]
    then
        scenarios=("${scenarios[@]}" $t/*.sh)
    else
        scenarios=("${scenarios[@]}" $t)
    fi
done
set -- "${scenarios[@]}"

let passed=0 failed=0 errored=0
for t in "$@"
do
    if ! $quiet
    then
        echo "${pbold}Test script${preset} ${t##*/}:"
    fi
    . $t
done

if ! $quiet
then
    cat <<EOS
${pbold}Summary${preset}: $passed PASSED, $failed FAILED, $errored ERRORED
EOS
fi

if (( 0 < errored ))
then
    exit 2
elif (( 0 < failed ))
then
    exit 1
fi
