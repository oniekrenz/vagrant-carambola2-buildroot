#!/bin/bash

CONFIG=config.yaml
VAGRANT=vagrant
VAGRANT_VERSION_REQUIRED=1.4.0


function readYaml () {
  cat $1 | sed "s/^$2 *: *\(.*\)$/\1/p;d"
}

function exitWithMessage () {
  echo -e "$1"
  exit 5
}

# function compareVersions from http://stackoverflow.com/questions/3511006/how-to-compare-versions-of-some-products-in-unix-shell
function compareVersions () {
  typeset    IFS='.'
  typeset -a v1=( $1 )
  typeset -a v2=( $2 )
  typeset    n diff

  for (( n=0; n<4; n+=1 )); do
    diff=$((v1[n]-v2[n]))
    if [ $diff -ne 0 ] ; then
      [ $diff -le 0 ] && echo '-1' || echo '1'
      return
    fi
  done
  echo  '0'
}

function checkExecutable () {
  which -s "$1" >/dev/null || exitWithMessage "$1 not found in PATH.\nAdd to path or install program. Visit $3"
  local current_version=`$1 --version | sed -E 's/^.*([0-9]+\.+[0-9]+\.[0-9]+).*$/\1/g'`
  test `compareVersions $current_version "$2"` -lt 0 && exitWithMessage "$1 $current_version is too old.\nAt least $2 is required."
}

function checkVagrantBoxExists () {
  test -z "$HOST_BOX" && exitWithMessage "Variable 'box' not set in $CONFIG. You must specify which box you want to use."
  test `$VAGRANT box list | grep -c "^$HOST_BOX"` -eq 0 && exitWithMessage "Missing $VAGRANT box '$HOST_BOX'.\nTo install execute:\n $>'$VAGRANT box add --name $HOST_BOX http://puppet-vagrant-boxes.puppetlabs.com/'"
}

function checkVagrantPlugin () {
  local current_version=`$VAGRANT plugin list | sed -E "s/$1 +\(([0-9]+\.+[0-9]+\.[0-9]+)\).*$/\1/g p;d"`
  test -z "$current_version" && exitWithMessage "Missing $VAGRANT plugin '$1'.\nTo install execute:\n $>sudo gem install $1\n $>$VAGRANT plugin install $1\nVisit $3"
  test `compareVersions $current_version "$2"` -lt 0 && exitWithMessage "vagrant plugin $1 $current_version is too old.\nAt least $2 is required."
}

HOST_BOX=$(readYaml $CONFIG box)


checkExecutable $VAGRANT $VAGRANT_VERSION_REQUIRED 'https://www.vagrantup.com/'
checkVagrantBoxExists
checkVagrantPlugin librarian-puppet 0.8.0 'http://librarian-puppet.com/'
checkVagrantPlugin facter 1.6.0 'https://docs.puppetlabs.com/facter/'
