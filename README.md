# Conky

> **NOTICE:** Source is originally a Conky project at [https://github.com/brndnmtthws/conky](https://github.com/brndnmtthws/conky). This is conky-lua-nv AUR fork and it has been completely edited by Claude 3.7 Sonnet Thinking model.

[![Build and test on Linux](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml)
[![Build AppImage](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml)
[![Build and test on MacOS](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-macos.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-macos.yaml)
[![Docker](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/docker.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/docker.yaml)

---

Conky is a system monitor for X originally based on the torsmo code. Since its original conception, Conky has changed significantly from its predecessor, while maintaining simplicity and configurability. Conky can display just about anything, either on your root desktop or in its own window. Conky has many built-in objects, as well as the ability to execute programs and scripts, then display the output from stdout.

**Key Improvement in This Fork:** This repository contains a modified version of Conky that **fixes the network speed graph functionality** to allow **independent scaling of upload and download speed graphs**. In standard Conky, both graphs use the same scale, which often makes one graph appear tiny when the other is much larger (e.g., when download speeds are much faster than upload speeds). This version enables each graph to scale independently for better visualization.

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

Conky uses a configuration file typically located at `~/.config/conky/conky.conf`.

### Default Conky Configuration

When Conky is freshly installed, it uses the following default configuration. This is what you'll get if you don't create your own configuration file:

```lua
-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.

conky.config = {
    alignment = 'top_left',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=12',
    gap_x = 60,
    gap_y = 60,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'normal',
    own_window_hints = 'undecorated,sticky,below,skip_taskbar,skip_pager',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[
${color grey}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color grey}Uptime:$color $uptime
${color grey}Frequency (in MHz):$color $freq
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
${color grey}Networking:
Up:$color ${upspeed} ${color grey} - Down:$color ${downspeed}
$hr
${color grey}Name              PID     CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]
```

> **Note:** To customize Conky, copy the above configuration to `~/.config/conky/conky.conf` and modify it to suit your needs.

<br>

## 🛠️ Bonus scripts and configuration

This section contains additional scripts and configurations to enhance your Conky experience.

### Enhanced Network Speed Configuration (With LUA Script)

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

### Top CPU Applications Script

Displays the top CPU-consuming applications in your Conky display.

Save as `~/.config/conky/top_cpu_apps.sh` and make it executable:
```bash
chmod +x ~/.config/conky/top_cpu_apps.sh
```

To use in your `conky.conf`:
```lua
${execpi 10 ~/.config/conky/top_cpu_apps.sh}
```

This script shows up to 10 applications using the most CPU, with their CPU usage percentage scaled by the number of cores.

### Top Memory Applications Script

Displays the top memory-consuming applications in your Conky display.

Save as `~/.config/conky/top_mem_apps.sh` and make it executable:
```bash
chmod +x ~/.config/conky/top_mem_apps.sh
```

This script requires the `smem` utility to be installed:
```bash
# Debian/Ubuntu
sudo apt install smem

# Arch Linux
sudo pacman -S smem
```

To use in your `conky.conf`:
```lua
${execpi 30 ~/.config/conky/top_mem_apps.sh}
```

This script shows up to 10 applications using the most memory, with values in MB or GB.

### Storage Drive Temperature Script

Gets the temperature of a storage device using smartctl.

Save as `~/.config/conky/get_temp.sh` and make it executable:
```bash
chmod +x ~/.config/conky/get_temp.sh
```

This script requires `smartmontools`:
```bash
# Debian/Ubuntu
sudo apt install smartmontools

# Arch Linux
sudo pacman -S smartmontools
```

To use in your `conky.conf`:
```lua
HDD: ${execpi 30 ~/.config/conky/get_temp.sh /dev/sda}
SSD: ${execpi 30 ~/.config/conky/get_temp.sh /dev/nvme0n1}
```

Replace `/dev/sda` and `/dev/nvme0n1` with your actual drive paths.

### CPU Power Monitoring Scripts

A collection of scripts to monitor CPU power consumption using Intel RAPL (Running Average Power Limit) interface.

1. **cpu_power.sh** - Shows current CPU power consumption in watts
```bash
#!/bin/bash
FILE="/sys/class/powercap/intel-rapl:0/energy_uj"
START=$(cat "$FILE")
sleep 1
END=$(cat "$FILE")
WATTS=$(echo "scale=2; ($END - $START)/1000000" | /usr/bin/bc)
echo "${WATTS}"
```

2. **cpu_power_log.sh** - Logs CPU power consumption to /tmp/cpu_power.log
```bash
#!/bin/bash
FILE="/sys/class/powercap/intel-rapl:0/energy_uj"
LOG="/tmp/cpu_power.log"

START=$(cat "$FILE")
sleep 1
END=$(cat "$FILE")
WATTS=$(echo "scale=2; ($END - $START)/1000000" | /usr/bin/bc)

# Keep last 60 values
tail -n 59 "$LOG" 2>/dev/null > "${LOG}.tmp"
echo "$WATTS" >> "${LOG}.tmp"
mv "${LOG}.tmp" "$LOG"
```

3. **cpu_power_latest.sh** - Shows the latest power reading from the log
```bash
#!/bin/bash
tail -n 1 /tmp/cpu_power.log
```

4. **cpu_power_peak.sh** - Shows the peak power consumption in the last 60 readings
```bash
#!/bin/bash
tail -n 60 /tmp/cpu_power.log | sort -n | tail -n 1 | xargs printf "%.1f\n"
```

Save these in `~/.config/conky/` and make them executable:
```bash
chmod +x ~/.config/conky/cpu_power*.sh
```

These scripts require the powercap interface to be available (typically on Intel CPUs). Set up a cron job to run the logging script periodically:
```bash
# Add to crontab -e
* * * * * ~/.config/conky/cpu_power_log.sh
```

To use in your `conky.conf`:
```lua
CPU Power: ${execpi 2 ~/.config/conky/cpu_power.sh} W (Peak: ${execpi 10 ~/.config/conky/cpu_power_peak.sh} W)
```

### Conky Installer Script

This script is **optional** and separate from the main Conky installation. While building from source installs the Conky binary and necessary libraries, this script helps with setting up your personal Conky environment.

**When to use this script:**
- After installing Conky (either from source or package manager)
- When you want to set up Conky to start automatically at boot
- When you need to install fonts, dependencies, and configure directories for Conky

**What this script does:**
- Creates the necessary configuration directories (`~/.config/conky`, `~/.config/autostart`)
- Sets up Conky to autostart when you log in
- Installs the required fonts
- Installs dependencies based on your Linux distribution
- Copies configuration files to the proper locations

The script is intended as a one-time setup tool to prepare your system for using Conky with a proper configuration environment.

To use the script:
```bash
# 1. First install Conky from source or package manager
# 2. Then run the installer script to set up your environment
cd ~/.config/conky
./install-conky.sh
```

> **Note:** Review the script content before running it to ensure it's suitable for your system.

<br>

## 📝 License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.

<br>

## 👏 Acknowledgments

* Original Conky developers and contributors
* The Linux community for continuous support
