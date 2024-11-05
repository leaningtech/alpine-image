#!/usr/bin/env sh

MY_DIR=`dirname "$(readlink -f "$0")"`

buildah bud --layers -t alpine_root -f Dockerfile

buildah bud --layers -t export -f export.dockerfile -v ${MY_DIR}:/export
