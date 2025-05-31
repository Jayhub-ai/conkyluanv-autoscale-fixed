# Conky

[![Build and test on Linux](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml)
[![Build AppImage](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml)

Conky is a system monitor for X originally based on the torsmo code. Since its original conception, Conky has changed significantly from its predecessor, while maintaining simplicity and configurability. Conky can display just about anything, either on your root desktop or in its own window. Conky has many built-in objects, as well as the ability to execute programs and scripts, then display the output from stdout.

This repository contains a modified version of Conky with enhanced network speed graph functionality allowing independent scaling of upload and download speed graphs.

## Features

- All standard Conky features
- Independent scaling for upload and download speed graphs
- LUA scripting support for enhanced customization
- NVIDIA GPU monitoring support
- Network traffic monitoring and graphing

## Getting Started

### Prerequisites

To build Conky from source, you'll need the following dependencies:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential cmake libx11-dev libxdamage-dev libxft-dev libxinerama-dev libxml2-dev libxext-dev libcurl4-openssl-dev liblua5.3-dev libcairo2-dev libimlib2-dev libxnvctrl-dev

# Arch Linux
sudo pacman -S base-devel cmake libx11 libxdamage libxft libxinerama libxml2 libxext curl lua cairo imlib2 nvidia-utils
```

### Building from Source

1. Clone the repository:

```bash
git clone https://github.com/Split1700/conkyluanv-autoscale-fixed.git
cd conkyluanv-autoscale-fixed
```

2. Create a build directory and compile:

```bash
mkdir build
cd build
cmake .. -DBUILD_NVIDIA=ON -DBUILD_LUA_CAIRO=ON -DBUILD_LUA_IMLIB2=ON
make
```

3. Install:

```bash
sudo make install
```

### AppImage Support

AppImage builds are configured but not yet available as releases. You can build your own AppImage by using the workflow in `.github/workflows/publish-appimage.yml` as a reference.

## Configuration

Conky uses a configuration file typically located at `~/.config/conky/conky.conf`. A sample configuration is provided in the `data` directory.

Example configuration to show network graphs with independent scaling:

```lua
-- Conky configuration with modified network speed graphs

conky.config = {
    alignment = 'top_right',            -- Position of the Conky window on screen
    background = true,                  -- Run Conky in the background
    double_buffer = true,               -- Reduces flicker
    use_xft = true,                     -- Use Xft for font rendering
    font = 'DejaVu Sans Mono:size=12',  -- Font to use for text
    draw_graph_borders = true,          -- Draw borders around graphs
    update_interval = 1.0,              -- Update interval in seconds
    lua_load = '~/.config/conky/netspeed_conversion.lua', -- Load Lua script for network speed conversion
}

conky.text = [[
${color gray}Networking:
${color gray}Download: $color${lua conky_netspeed enp0s31f6 down} ${alignr}${color gray}Upload: $color${lua conky_netspeed enp0s31f6 up}
${color gray}${downspeedgraph enp0s31f6 40,180 1B7E1B 32CD32 -t} ${alignr}${color gray}${upspeedgraph enp0s31f6 40,180 831616 B22222 -t}
]]
```

Save this Lua script as `~/.config/conky/netspeed_conversion.lua` to display network speeds in Kbps/Mbps:

```lua
-- Get the raw value from Conky and turn commas into dots
local function get_kib(dev, dir)
    local macro = dir=="up"
      and "${upspeedf "..dev.."}"
      or "${downspeedf "..dev.."}"
    local raw = conky_parse(macro)
    raw = raw and raw:gsub(",",".") or "0"
    return tonumber(raw) or 0
end

-- Format bits/sec intelligently
local function fmt_bits(bits)
    if bits < 1024 then
        return string.format("%.1f Kbps", bits)
    else
        return string.format("%.1f Mbps", bits/1024)
    end
end

-- Conky entry point: conky_netspeed(dev, "up"|"down")
function conky_netspeed(dev, dir)
    local kib = get_kib(dev, dir)
    local bits = kib * 8           -- KiB → Kb
    return fmt_bits(bits)
end
```

## License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.

## Acknowledgments

* Original Conky developers and contributors
* The Linux community for continuous support
