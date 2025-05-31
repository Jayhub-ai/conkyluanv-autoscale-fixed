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
        echo "Error: Can't download $sccache_url." >&2
        return 1
    fi
    
    if [ ! -f "$sccache_archive.tar.gz" ]; then
        echo "Error: Download completed but file $sccache_archive.tar.gz not found." >&2
        return 1
    fi
    
    echo "Extracting $sccache_archive.tar.gz..."
    if ! tar -xzf "$sccache_archive.tar.gz" >/dev/null; then
        echo "Error: Can't extract $sccache_archive.tar.gz" >&2
        return 1
    fi
    
    if [ ! -d "$sccache_archive" ]; then
        echo "Error: Extraction completed but directory $sccache_archive not found." >&2
        return 1
    fi
    
    if [ ! -f "$sccache_archive/sccache" ]; then
        echo "Error: sccache binary not found in extracted archive." >&2
        return 1
    fi
    
    chmod +x "$sccache_archive/sccache"
    if ! sudo cp "$sccache_archive/sccache" "/usr/local/bin/sccache"; then
        echo "Error: Failed to copy sccache to /usr/local/bin/sccache" >&2
        return 1
    fi
    
    echo "Cleaning up temporary files..."
    rm -rf "$sccache_archive.tar.gz"
    rm -rf "$sccache_archive"
    
    # Verify installation
    if ! command -v sccache >/dev/null 2>&1; then
        echo "Error: sccache command not found after installation." >&2
        return 1
    fi
    
    echo "sccache installation successful."
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
    echo "Starting sccache server..."
    if ! sccache --start-server; then
        echo "Warning: Failed to start sccache server, continuing anyway" >&2
    else
        echo "sccache server started successfully."
    fi
else
    echo "Warning: sccache command not found, continuing without it" >&2
    # Set a flag to indicate sccache is not available
    echo "SCCACHE_UNAVAILABLE=true" >>$GITHUB_ENV
fi

echo "sccache setup completed."
