#!/usr/bin/env bash
###############################################################################
##
##       filename: app.sh
##    description: utils for app dev on macOS
##        created: 2023/10/02
##         author: ticktechman
##
###############################################################################

function dmg.init() {
  [[ $# -ne 1 ]] && {
    echo "usage: dmg.init <release-folder>"
    return 1
  }
  mkdir "$1" && ln -s /Applications "$1/" || {
    echo "=> dmg init failed"
    return 1
  }
}

function dmg.create() {
  [[ $# -ne 1 ]] && {
    echo "usage: dmg.create <release-folder>"
    return 1
  }
  local tmp=".tmp.dmg"
  local pkg="$1"
  rm -f "${pkg}.dmg" &&
    hdiutil create "$tmp" -ov -volname "$pkg" -fs APFS -srcfolder "${pkg}" &&
    hdiutil convert "$tmp" -format UDZO -o "${pkg}.dmg" &&
    rm -f "${tmp}" &&
    echo "=> success" || {
    echo "=> failed"
    rm -f ${tmp}
    return 1
  }
}

function dmg.pack() {
  [[ $# -ne 1 ]] && {
    echo "usage: dmg.pack <app-folder>"
    return 1
  }
  local app="$(basename $1)"
  app="${app%.app}"
  dmg.init "$app" &&
    cp -a "$1" "${app}/" &&
    dmg.create "${app}" ||
    return 1
}
###############################################################################
