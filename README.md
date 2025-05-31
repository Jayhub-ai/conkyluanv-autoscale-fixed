# Conky

[![Build and test on Linux](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml)
[![Build AppImage](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml)

---

Conky is a system monitor for X originally based on the torsmo code. Since its original conception, Conky has changed significantly from its predecessor, while maintaining simplicity and configurability. Conky can display just about anything, either on your root desktop or in its own window. Conky has many built-in objects, as well as the ability to execute programs and scripts, then display the output from stdout.

This repository contains a modified version of Conky with enhanced network speed graph functionality allowing independent scaling of upload and download speed graphs.

<br>

## ✨ Features

- All standard Conky features
- Improved, independent scaling for upload and download speed graphs
- LUA scripting support for enhanced customization
- NVIDIA GPU monitoring support

<br>

## 🚀 Getting Started

### Prerequisites

To build Conky from source, you'll need the following dependencies:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential cmake libx11-dev libxdamage-dev libxft-dev libxinerama-dev libxml2-dev libxext-dev libcurl4-openssl-dev liblua5.3-dev libcairo2-dev libimlib2-dev libxnvctrl-dev

# Arch Linux
sudo pacman -S base-devel cmake libx11 libxdamage libxft libxinerama libxml2 libxext curl lua cairo imlib2 nvidia-utils
```

<br>

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

<br>

### AppImage Support

AppImage builds are configured but not yet available as releases. You can build your own AppImage by using the workflow in `.github/workflows/publish-appimage.yml` as a reference.

<br>

## ⚙️ Configuration

Conky uses a configuration file typically located at `~/.config/conky/conky.conf`. There are two ways to configure the network monitoring functionality:

<br>

### Option 1: Standard Configuration (No LUA Required)

This approach uses Conky's built-in variables for network monitoring. It's simpler but displays speeds in KiB/s (kibibytes per second).

```lua
-- Standard Conky configuration with built-in network monitoring

conky.config = {
    alignment = 'top_right',
    background = true,
    double_buffer = true,
    use_xft = true,
    font = 'DejaVu Sans Mono:size=12',
    draw_graph_borders = true,
    update_interval = 1.0,
}

conky.text = [[
${color gray}Networking:
${color gray}Download: $color${downspeed wlan0} ${alignr}${color gray}Upload: $color${upspeed wlan0}
${color gray}${downspeedgraph wlan0 40,180 1B7E1B 32CD32 -t} ${alignr}${color gray}${upspeedgraph wlan0 40,180 831616 B22222 -t}
]]
```

> **Note:** Replace `wlan0` with your actual network interface name. You can find it by running `ip a` or `ifconfig`.

<br>

### Option 2: Enhanced Configuration (With LUA Script)

This approach uses a LUA script to convert network speeds to Kbps/Mbps (kilobits/megabits per second), which is how internet speeds are typically advertised.

#### Step 1: Create the LUA Script

Save this as `~/.config/conky/netspeed_conversion.lua`:

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

#### Step 2: Configure Conky to Use the Script

Update your `~/.config/conky/conky.conf` to load and use the LUA script:

```lua
-- Enhanced Conky configuration with LUA-based network speed conversion

conky.config = {
    alignment = 'top_right',
    background = true,
    double_buffer = true,
    use_xft = true,
    font = 'DejaVu Sans Mono:size=12',
    draw_graph_borders = true,
    update_interval = 1.0,
    lua_load = '~/.config/conky/netspeed_conversion.lua', -- Load our LUA script
}

conky.text = [[
${color gray}Networking:
${color gray}Download: $color${lua conky_netspeed wlan0 down} ${alignr}${color gray}Upload: $color${lua conky_netspeed wlan0 up}
${color gray}${downspeedgraph wlan0 40,180 1B7E1B 32CD32 -t} ${alignr}${color gray}${upspeedgraph wlan0 40,180 831616 B22222 -t}
]]
```

> **Note:** Replace `wlan0` with your actual network interface name.

<br>

## 📝 License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.

<br>

## 👏 Acknowledgments

* Original Conky developers and contributors
* The Linux community for continuous support
