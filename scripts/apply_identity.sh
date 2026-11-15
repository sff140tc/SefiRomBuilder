
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
CONFIG="$ROOT/config/rom_identity.env"
BUILD_PROP="$FIRM_DIR/system/system/build.prop"

if [[ ! -f "$CONFIG" ]]; then
    echo "SefiROM identity configuration missing."
    exit 1
fi

if [[ ! -f "$BUILD_PROP" ]]; then
    echo "System build.prop not found."
    exit 1
fi

source "$CONFIG"

set_prop() {
    local key="$1"
    local value="$2"

    if grep -q "^${key}=" "$BUILD_PROP"; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$BUILD_PROP"
    else
        echo "${key}=${value}" >> "$BUILD_PROP"
    fi
}

set_prop "ro.sefirom.name" "$SEFIROM_NAME"
set_prop "ro.sefirom.version" "$SEFIROM_VERSION"
set_prop "ro.sefirom.developer" "$SEFIROM_DEVELOPER"
set_prop "ro.sefirom.maintainer" "$SEFIROM_MAINTAINER"
set_prop "ro.sefirom.buildtype" "$SEFIROM_BUILD_TYPE"
set_prop "ro.sefirom.description" "$SEFIROM_DESCRIPTION"

echo "SefiROM identity properties injected successfully."
