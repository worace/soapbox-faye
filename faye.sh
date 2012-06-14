#!/usr/bin/env bash
set -e

export rvm_trust_rvmrcs_flag=1
DIR="$( cd "$( dirname "$0" )" && pwd )"

if [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  source "/usr/local/rvm/scripts/rvm"
elif [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
fi

cd "$DIR"

# start|stop
exec ./daemon.rb $1
