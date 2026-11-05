#!/usr/bin/env bash
set -euo pipefail
APPIMAGE_ARCH=x86_64 exec "$(dirname "${BASH_SOURCE[0]}")/build-appimage.sh" "$@"
