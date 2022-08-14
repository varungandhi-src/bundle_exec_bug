#!/usr/bin/env bash
set -x
"$_BUNDLE" --version
"$_BUNDLE" install
find "$_RUBY_ROOT" -name 'srb' -type f
"$_BUNDLE" exec 'echo $PATH'
"$_BUNDLE" exec which srb
"$_BUNDLE" info sorbet
