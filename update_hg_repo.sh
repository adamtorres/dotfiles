#! /bin/bash
. ~/.profile
pushd $1
hg pull
popd
