#!/bin/sh

export SCCACHE_VERSION="${SCCACHE_VERSION:=0.9.1}"

export sccache_arch="x86_64"
if [ "$RUNNER_ARCH" = "X86" ]; then
    export sccache_arch="i686"
elif [ "$RUNNER_ARCH" = "X64" ]; then
    export sccache_arch="x86_64"
elif [ "$RUNNER_ARCH" = "ARM" ]; then
    export sccache_arch="armv7"
elif [ "$RUNNER_ARCH" = "ARM64" ]; then
    export sccache_arch="aarch64"
fi

install_sccache() {
    export sccache_archive="sccache-v$SCCACHE_VERSION-$sccache_arch-$sccache_os"
    export sccache_url="https://github.com/mozilla/sccache/releases/download/v$SCCACHE_VERSION/$sccache_archive.tar.gz"

    echo "Downloading $sccache_url..."
    if ! wget -q "$sccache_url"; then
        echo "Can't download $sccache_url." >&2
        return 1
    fi
    echo "Extracting $sccache_archive.tar.gz..."
    if ! tar -xzf "$sccache_archive.tar.gz" >/dev/null; then
        echo "Can't extract $sccache_archive.tar.gz" >&2
        return 1
    fi
    chmod +x "$sccache_archive/sccache"
    sudo cp "$sccache_archive/sccache" "/usr/local/bin/sccache"
    rm -rf "$sccache_archive.tar.gz"
    rm -rf "$sccache_archive"
    return 0
}

export sccache_os="unknown-linux-musl"
if [ "$RUNNER_OS" = "Linux" ]; then
    export sccache_os="unknown-linux-musl"
    if [ "$RUNNER_ARCH" = "ARM" ]; then
        export sccache_os="unknown-linux-musleabi"
    fi
    if ! install_sccache; then
        echo "Unable to install sccache! Will continue without it." >&2
    fi
elif [ "$RUNNER_OS" = "macOS" ]; then
    export sccache_os="apple-darwin"
    if ! install_sccache; then
        echo "Unable to install sccache! Will continue without it." >&2
    fi
elif [ "$RUNNER_OS" = "Windows" ]; then
    export sccache_os="pc-windows-msvc"
    if ! install_sccache; then
        echo "Unable to install sccache! Will continue without it." >&2
    fi
fi

echo "sccache installed."

# Configure
mkdir -p $HOME/.sccache
chmod -R 755 $HOME/.sccache || true
echo "SCCACHE_DIR=$HOME/.sccache" >>$GITHUB_ENV
if [ "$RUNNER_DEBUG" = "1" ]; then
    echo "Running with debug output; cached binary artifacts will be ignored to produce a cleaner build"
    echo "SCCACHE_RECACHE=true" >>$GITHUB_ENV
fi

# Set SCCACHE_CACHE_SIZE with a reasonable default
echo "SCCACHE_CACHE_SIZE=5G" >>$GITHUB_ENV

# Initialize sccache but don't fail if it doesn't work
if command -v sccache >/dev/null 2>&1; then
    sccache --start-server || echo "Failed to start sccache server, continuing anyway"
else
    echo "sccache command not found, continuing without it"
fi

echo "sccache setup completed."
