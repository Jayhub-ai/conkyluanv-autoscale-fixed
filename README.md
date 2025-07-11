# Conky

> **NOTICE:** Source is originally a Conky project at [https://github.com/brndnmtthws/conky](https://github.com/brndnmtthws/conky). This is conky-lua-nv AUR fork and it has been completely edited by Claude 3.7 Sonnet Thinking model.

[![Build and test on Linux](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-linux.yaml)
[![Build AppImage](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/publish-appimage.yml)
[![Build and test on MacOS](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-macos.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/build-and-test-macos.yaml)
[![Docker](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/docker.yaml/badge.svg)](https://github.com/Split1700/conkyluanv-autoscale-fixed/actions/workflows/docker.yaml)

---
<!-- TOC -->
- [✨ Features](#-features)
- [🚀 Getting Started](#-getting-started)
- [⚙️ Configuration](#️-configuration)
- [🛠️ Bonus scripts and configuration](#%EF%B8%8F-bonus-scripts-and-configuration)
- [📝 License](#-license)
- [👏 Acknowledgments](#-acknowledgments)
<!-- /TOC -->

Conky is a system monitor for X originally based on the torsmo code. Since its original conception, Conky has changed significantly from its predecessor, while maintaining simplicity and configurability. Conky can display just about anything, either on your root desktop or in its own window. Conky has many built-in objects, as well as the ability to execute programs and scripts, then display the output from stdout.

**Key Improvement in This Fork:** This repository contains a modified version of Conky that **fixes the network speed graph functionality** to allow **independent scaling of upload and download speed graphs**. In standard Conky, both graphs use the same scale, which often makes one graph appear tiny when the other is much larger (e.g., when download speeds are much faster than upload speeds). This version enables each graph to scale independently for better visualization.

[▶️ Watch explanatory Youtube video](https://www.youtube.com/watch?v=AqH50KSWfw4)

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

<details>
<summary>Click to view default configuration</summary>

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
</details>

> **Note:** To customize Conky, copy the above configuration to `~/.config/conky/conky.conf` and modify it to suit your needs.

<br>

## 🛠️ Bonus scripts and configuration

This section contains additional scripts and configurations to enhance your Conky experience.

### Enhanced Network Speed Configuration (With LUA Script)

This approach uses a LUA script to convert network speeds to Kbps/Mbps (kilobits/megabits per second), which is how internet speeds are typically advertised.

#### Step 1: Create the LUA Script

Save this as `~/.config/conky/netspeed_conversion.lua`:

<details>
<summary>netspeed_conversion.lua (click to expand)</summary>

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
</details>

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

<details>
<summary>top_cpu_apps.sh (click to expand)</summary>

```bash
#!/bin/bash

CORES=$(nproc)

ps -eo comm,pcpu --no-headers | \
awk -v cores="$CORES" '{
    cpu[$1] += $2
}
END {
    for (p in cpu)
        printf "%s %.1f\n", p, cpu[p] / cores
}' | sort -k2 -nr | head -n 10 | \
awk '{
    name = substr($1, 1, 12)
    while (length(name) < 12) name = name " "
    printf "${color}${goto 15}|${goto 40}|${goto 60}+--${color3}%-12s %5.1f%%%s\n", name, $2, "${color}"
}'
```
</details>

To use in your `conky.conf`:
```lua
${execpi 10 ~/.config/conky/top_cpu_apps.sh}
```

This script shows up to 10 applications using the most CPU, with their CPU usage percentage scaled by the number of cores.

### Top Memory Applications Script

Displays the top memory-consuming applications in your Conky display.

Save as `~/.config/conky/top_mem_apps.sh` and make it executable:

<details>
<summary>top_mem_apps.sh (click to expand)</summary>

```bash
#!/bin/bash

LIMIT=10
SMEM_OUT=$(smem -r -c "name pss" 2>/dev/null)

echo "$SMEM_OUT" | \
awk 'NR>1 {data[$1] += $2} END {
  for (name in data)
    printf "%s %.1f\n", name, data[name]/1000
}' | \
sort -k2 -nr | head -n "$LIMIT" | \
awk 'BEGIN { OFS="" }
{
  val = $2
  unit = "MB"
  if (val >= 1000) {
    val = val / 1000
    unit = "GB"
  }
  name = substr($1, 1, 12)
  while (length(name) < 12) name = name " "
  printf "${color}${goto 262}+--${color3}%-12s %6.1f %s${color}\n", name, val, unit
}'
```
</details>

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

<details>
<summary>get_temp.sh (click to expand)</summary>

```bash
#!/bin/bash
DEVICE="$1"

sudo /usr/bin/smartctl -A "$DEVICE" \
  | awk '
    /Temperature_Celsius|Airflow_Temperature|Composite Temperature/ {
      match($0, /[0-9]+[[:space:]]+\([^\)]*\)|[0-9]+$/);
      if (RSTART > 0) {
        temp = substr($0, RSTART, RLENGTH);
        gsub(/ .*/, "", temp); # Strip anything after first space (like (Min/Max...))
        print temp "°C";
        found = 1;
        exit;
      }
    }
    END { if (!found) print "N/A" }
'
```
</details>

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

| Script | Purpose |
|--------|---------|
| cpu_power.sh | Current CPU power consumption in watts |
| cpu_power_log.sh | Append one-second sample to /tmp/cpu_power.log |
| cpu_power_latest.sh | Show the latest power reading from the log |
| cpu_power_peak.sh | Peak power consumption over the last 60 readings |

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

### CPU Temperature Monitoring Fix

This section addresses a race condition bug in Conky's hwmon temperature sensor implementation that can cause erratic CPU temperature readings.

#### The Problem

The original Conky implementation had a race condition in the hwmon sensor reading code (`src/data/os/linux.cc`) where multiple temperature sensors would share a global variable, causing inconsistent and erratic temperature values when reading CPU temperatures with variables like `${hwmon coretemp temp 1}`.

#### The Fix

This fork includes a fix that eliminates the race condition by:

1. **Removing the global `temp2` variable** that was causing the race condition
2. **Using local variables** in the `get_sysfs_info()` function instead of global state
3. **Updating the `print_sysfs_sensor()` function** to use local sensor type information

#### CPU Temperature Averaging Script

For even more stable temperature readings, you can use an average of all CPU core temperatures instead of the package temperature. This provides smoother, more realistic temperature values.

Save this as `~/.config/conky/cpu_temp_avg.sh` and make it executable:

<details>
<summary>cpu_temp_avg.sh (click to expand)</summary>

```bash
#!/bin/bash

# Calculate average CPU temperature from all cores
# This provides more stable readings than the package temperature

# Get temperatures from all available cores (temp2 through temp5)
temp2=$(cat /sys/class/hwmon/hwmon3/temp2_input 2>/dev/null || echo "0")
temp3=$(cat /sys/class/hwmon/hwmon3/temp3_input 2>/dev/null || echo "0")
temp4=$(cat /sys/class/hwmon/hwmon3/temp4_input 2>/dev/null || echo "0")
temp5=$(cat /sys/class/hwmon/hwmon3/temp5_input 2>/dev/null || echo "0")

# Count valid temperatures (non-zero)
count=0
sum=0

if [ "$temp2" -gt 0 ]; then
    sum=$((sum + temp2))
    count=$((count + 1))
fi

if [ "$temp3" -gt 0 ]; then
    sum=$((sum + temp3))
    count=$((count + 1))
fi

if [ "$temp4" -gt 0 ]; then
    sum=$((sum + temp4))
    count=$((count + 1))
fi

if [ "$temp5" -gt 0 ]; then
    sum=$((sum + temp5))
    count=$((count + 1))
fi

# Calculate average in Celsius (divide by 1000 for millidegrees)
if [ $count -gt 0 ]; then
    avg_temp=$((sum / count))
    # Convert to Celsius with one decimal place
    celsius=$(echo "scale=1; $avg_temp / 1000" | bc -l)
    echo "$celsius"
else
    echo "N/A"
fi
```
</details>

**Note:** The provided script assumes your CPU has 4 physical cores (using temp2_input through temp5_input). If your CPU has more or fewer cores, add or remove tempN_input lines accordingly. For example, for a 6-core CPU, add temp6_input and temp7_input, and update the averaging logic to include those sensors. Each tempN_input typically corresponds to a core as labeled in `/sys/class/hwmon/hwmon3/`.

Make the script executable:
```bash
chmod +x ~/.config/conky/cpu_temp_avg.sh
```

To use in your `conky.conf`, replace:
```lua
${hwmon coretemp temp 1} °C
```

With:
```lua
${execi 2 ~/.config/conky/cpu_temp_avg.sh} °C
```

**Benefits of using the average:**
- **More stable readings**: Package temperature can spike rapidly due to single-core loads
- **Realistic values**: Represents the typical CPU temperature across all cores
- **Less erratic display**: Smoother temperature changes in your Conky display

**Note:** The average will typically be lower than the package temperature since it represents the average across all cores rather than the hottest spot on the CPU package.

### Hardware-Based Drive Monitoring Scripts

Monitor drive free space by hardware identifiers (serial numbers, model names) instead of mount points. This ensures your monitoring continues to work even when mount points change or drives are remounted.

#### Why Use Hardware-Based Monitoring?

Traditional drive monitoring relies on fixed mount points (like `/mnt/backup` or `/media/user/drive`). However, mount points can change when:
- System updates modify mounting behavior
- Drives are mounted by different services (like Timeshift)
- You switch between manual and automatic mounting
- Mount locations change between `/media/`, `/mnt/`, or `/run/media/`

This solution identifies drives by their permanent hardware characteristics, making monitoring more reliable.

#### Main Script: find_drive_by_hardware.sh

This is the core script that finds drives by their hardware identifiers.

Save as `~/.config/conky/find_drive_by_hardware.sh` and make it executable:

<details>
<summary>find_drive_by_hardware.sh (click to expand)</summary>

```bash
#!/bin/bash

# Find and monitor drives by their hardware characteristics (serial, model, size)
# These don't change when you format the drive
# Usage: ./find_drive_by_hardware.sh "identifier"
#        where identifier can be:
#        - Serial number (most reliable)
#        - Model name
#        - Model:Size combination
#        - Custom identifier from config file

IDENTIFIER="$1"
CONFIG_FILE="$HOME/.config/conky/drive_mappings.conf"

if [ -z "$IDENTIFIER" ]; then
    echo "Not mounted"
    exit 1
fi

# Function to get drive info using lsblk
get_drive_info() {
    # Get serial, model, size, mountpoint for all block devices
    lsblk -o NAME,SERIAL,MODEL,SIZE,MOUNTPOINT,TYPE -P 2>/dev/null | grep 'TYPE="disk"\|TYPE="part"'
}

# Function to find by serial number
find_by_serial() {
    local serial="$1"
    local mount_point
    
    # First find the device name by serial
    local device=$(lsblk -o NAME,SERIAL -rn | grep -i "${serial}" | awk '{print $1}' | head -n1)
    
    if [ -n "$device" ]; then
        # Then find any mountpoint for that device or its partitions
        mount_point=$(lsblk -o NAME,MOUNTPOINT -rn | grep "^${device}" | awk '{print $2}' | grep -v '^$' | head -n1)
        if [ -n "$mount_point" ]; then
            echo "$mount_point"
            return 0
        fi
    fi
    return 1
}

# Function to find by model
find_by_model() {
    local model="$1"
    local mount_point
    
    # Try exact match first
    mount_point=$(lsblk -o MODEL,MOUNTPOINT -rn | grep -i "^${model}" | awk '{print $2}' | grep -v '^$' | head -n1)
    
    # If not found, try partial match
    if [ -z "$mount_point" ]; then
        mount_point=$(lsblk -o MODEL,MOUNTPOINT -rn | grep -i "${model}" | awk '{print $2}' | grep -v '^$' | head -n1)
    fi
    
    if [ -n "$mount_point" ]; then
        echo "$mount_point"
        return 0
    fi
    return 1
}

# Function to find by model and size combination
find_by_model_size() {
    local model="$1"
    local size="$2"
    local mount_point
    
    mount_point=$(lsblk -o MODEL,SIZE,MOUNTPOINT -rn | grep -i "${model}" | grep "${size}" | awk '{print $3}' | grep -v '^$' | head -n1)
    
    if [ -n "$mount_point" ]; then
        echo "$mount_point"
        return 0
    fi
    return 1
}

# Check if we have a config file with custom mappings
if [ -f "$CONFIG_FILE" ]; then
    # Read mapping from config file
    # Format: IDENTIFIER:SERIAL or IDENTIFIER:MODEL:SIZE
    while IFS=: read -r id value1 value2; do
        # Skip comment lines
        if [[ "$id" =~ ^[[:space:]]*# ]] || [ -z "$id" ]; then
            continue
        fi
        
        if [ "$id" = "$IDENTIFIER" ]; then
            if [ -n "$value2" ]; then
                # Model:Size format
                MOUNT_POINT=$(find_by_model_size "$value1" "$value2")
            else
                # Try as serial first, then as model
                MOUNT_POINT=$(find_by_serial "$value1") || MOUNT_POINT=$(find_by_model "$value1")
            fi
            break
        fi
    done < "$CONFIG_FILE"
fi

# If not found in config, try direct search
if [ -z "$MOUNT_POINT" ]; then
    # Try as serial number first (most specific)
    MOUNT_POINT=$(find_by_serial "$IDENTIFIER")
    
    # If not found, try as model name
    if [ -z "$MOUNT_POINT" ]; then
        MOUNT_POINT=$(find_by_model "$IDENTIFIER")
    fi
fi

# If we found a mount point, get the free space
if [ -n "$MOUNT_POINT" ] && [ -d "$MOUNT_POINT" ]; then
    FREE=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $4}')
    TOTAL=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $2}')
    
    # Handle different units properly
    FREE_NUM=$(echo "$FREE" | sed 's/[A-Za-z]*$//')
    TOTAL_NUM=$(echo "$TOTAL" | sed 's/[A-Za-z]*$//')
    FREE_UNIT=$(echo "$FREE" | sed 's/[0-9,.]*//g')
    TOTAL_UNIT=$(echo "$TOTAL" | sed 's/[0-9,.]*//g')
    
    if [ "$FREE_UNIT" = "$TOTAL_UNIT" ] && [[ "$FREE_UNIT" =~ ^[GT]$ ]]; then
        echo "${FREE_NUM}/${TOTAL_NUM}${FREE_UNIT}B"
    else
        echo "${FREE}/${TOTAL}"
    fi
else
    echo "Not mounted"
fi
```
</details>

#### Configuration File: drive_mappings.conf

This file maps friendly names to hardware identifiers.

Save as `~/.config/conky/drive_mappings.conf`:

```bash
# Drive mappings configuration
# Format: FRIENDLY_NAME:SERIAL_NUMBER
# or:     FRIENDLY_NAME:MODEL_NAME:SIZE
# 
# To find your drive's serial numbers and models, run:
# ~/.config/conky/list_drive_info.sh
#
# Examples:
# Backup_Drive:WD-WX11D12345678
# Data_SSD:Samsung_SSD_850:500G
# External_USB:ST2000DM008:1.8T
#
# Add your drive mappings below:
MyDrive1:YOUR_SERIAL_HERE
MyDrive2:YOUR_MODEL_HERE
MyDrive3:YOUR_MODEL_HERE:SIZE_HERE
```

#### Helper Script: list_drive_info.sh

This script helps you find the hardware identifiers for your drives.

Save as `~/.config/conky/list_drive_info.sh` and make it executable:

<details>
<summary>list_drive_info.sh (click to expand)</summary>

```bash
#!/bin/bash

# Clean drive information script (one line per physical disk)
# Shows SERIAL, MODEL, SIZE and any partition LABELs (decoded so spaces show
# correctly). Useful when several disks share the same model name.
#
# Columns: DISK | SERIAL | MODEL | SIZE | PARTITION_LABELS
#
# Usage: bash list_drive_info.sh

printf "%-6s %-18s %-28s %-8s %-s\n" "DISK" "SERIAL" "MODEL" "SIZE" "PARTITION_LABELS"
echo "---------------------------------------------------------------------------------------------"

# helper awk to safely parse lsblk -P output preserving spaces
awk_script='{
  for(i=1;i<=NF;i++){
    split($i,a,"="); key=a[1]; val=a[2]; gsub(/^\"|\"$/,"",val); data[key]=val;
  }
  printf "%s %s %s %s\n", data["NAME"], data["SERIAL"], data["MODEL"], data["SIZE"];
}'

while read -r NAME SERIAL MODEL SIZE; do
  # Collect partition labels (non-empty, comma-separated) and decode \xNN escapes
  LABELS=$(lsblk -r -n -o LABEL "/dev/$NAME" | awk 'NF' | while read -r L; do printf "%b\n" "$L"; done | paste -sd, -)
  [[ -z $LABELS ]] && LABELS="-"
  printf "%-6s %-18s %-28s %-8s %-s\n" "$NAME" "${SERIAL:--}" "${MODEL:--}" "$SIZE" "$LABELS"
done < <(lsblk -d -o NAME,SERIAL,MODEL,SIZE -P -n | awk "$awk_script")

echo
echo "Add drives to ~/.config/conky/drive_mappings.conf using the SERIAL or MODEL column above."
```
</details>

#### Drive-Specific Wrapper Scripts

Create wrapper scripts for each drive you want to monitor. Here are three examples:

**drive1_free.sh:**
```bash
#!/bin/bash
# Find drive by its hardware characteristics
exec ~/.config/conky/find_drive_by_hardware.sh "MyDrive1"
```

**drive2_free.sh:**
```bash
#!/bin/bash
# Find drive by its hardware characteristics
exec ~/.config/conky/find_drive_by_hardware.sh "MyDrive2"
```

**backup_drive_free.sh:**
```bash
#!/bin/bash
# Find backup drive by its hardware characteristics
exec ~/.config/conky/find_drive_by_hardware.sh "Backup_Drive"
```

Make all scripts executable:
```bash
chmod +x ~/.config/conky/find_drive_by_hardware.sh
chmod +x ~/.config/conky/list_drive_info.sh
chmod +x ~/.config/conky/drive1_free.sh
chmod +x ~/.config/conky/drive2_free.sh
chmod +x ~/.config/conky/backup_drive_free.sh
```

#### Complete Step-by-Step Setup Guide

This guide will walk you through setting up drive monitoring from scratch. No prior scripting knowledge required!

##### Step 1: Create the Main Scripts

First, we'll create the two main scripts that do all the work.

1. **Open a terminal** (Ctrl+Alt+T on most Linux systems)

2. **Create the configuration directory if it doesn't exist:**
   ```bash
   mkdir -p ~/.config/conky
   ```

3. **Create the main drive finder script:**
   ```bash
   nano ~/.config/conky/find_drive_by_hardware.sh
   ```
   
   Copy and paste the entire script content from the `find_drive_by_hardware.sh` section above, then:
   - Press `Ctrl+O` to save
   - Press `Enter` to confirm
   - Press `Ctrl+X` to exit

4. **Create the drive information helper script:**
   ```bash
   nano ~/.config/conky/list_drive_info.sh
   ```
   
   Copy and paste the entire script content from the `list_drive_info.sh` section above, then save and exit (Ctrl+O, Enter, Ctrl+X)

5. **Make both scripts executable:**
   ```bash
   chmod +x ~/.config/conky/find_drive_by_hardware.sh
   chmod +x ~/.config/conky/list_drive_info.sh
   ```

##### Step 2: Find Your Drive Information

1. **Run the drive information script:**
   ```bash
   ~/.config/conky/list_drive_info.sh
   ```

2. **You'll see output like this:**
   ```
   Drive Hardware Information
   =========================
   
   NAME        SERIAL              MODEL                    SIZE   LABEL           MOUNTPOINT
   ------------------------------------------------------------------------------------------
   sda         S1234567890ABC      WD Blue SSD              500.0G BackupDrive     /mnt/backup
   sdb         WD-WX11A12345678    WDC WD40EZRZ            4000.0G DataDrive       /media/data
   nvme0n1     S5678ABCD12345      Samsung SSD 980         1000.0G                 /
   ```

3. **Write down the information for drives you want to monitor:**
   - Note the SERIAL number (most reliable)
   - Or note the MODEL name
   - Also note any LABEL if you set one

##### Step 3: Create Your Configuration File

1. **Create the configuration file:**
   ```bash
   nano ~/.config/conky/drive_mappings.conf
   ```

2. **Add your drives using the information from Step 2:**
   ```bash
   # Drive mappings configuration
   # Format: FRIENDLY_NAME:SERIAL_NUMBER
   # or:     FRIENDLY_NAME:MODEL_NAME:SIZE
   
   # Example using the drives from step 2:
   # (Replace these with your actual drive information!)
   
   My_Backup:S1234567890ABC
   My_Storage:WD-WX11A12345678
   System_Drive:S5678ABCD12345
   External_USB:TOSHIBA_External:2000G
   ```
   
   **Important:** 
   - Replace `My_Backup`, `My_Storage`, etc. with whatever names you want to use
   - Replace the serial numbers with YOUR actual serial numbers from step 2
   - Don't use spaces in the friendly names (use underscores instead)

3. **Save the file** (Ctrl+O, Enter, Ctrl+X)

##### Step 4: Create Individual Scripts for Each Drive

For EACH drive in your configuration, you need to create a small script. Here's how:

1. **For your first drive (let's say you named it "My_Backup"):**
   ```bash
   nano ~/.config/conky/my_backup_free.sh
   ```
   
   Type exactly this (replacing `My_Backup` with YOUR friendly name from the config):
   ```bash
   #!/bin/bash
   exec ~/.config/conky/find_drive_by_hardware.sh "My_Backup"
   ```
   
   Save and exit (Ctrl+O, Enter, Ctrl+X)

2. **Make it executable:**
   ```bash
   chmod +x ~/.config/conky/my_backup_free.sh
   ```

3. **Repeat for each drive.** For example, if you have three drives:
   
   **Drive 2:**
   ```bash
   nano ~/.config/conky/my_storage_free.sh
   ```
   ```bash
   #!/bin/bash
   exec ~/.config/conky/find_drive_by_hardware.sh "My_Storage"
   ```
   ```bash
   chmod +x ~/.config/conky/my_storage_free.sh
   ```
   
   **Drive 3:**
   ```bash
   nano ~/.config/conky/system_drive_free.sh
   ```
   ```bash
   #!/bin/bash
   exec ~/.config/conky/find_drive_by_hardware.sh "System_Drive"
   ```
   ```bash
   chmod +x ~/.config/conky/system_drive_free.sh
   ```

##### Step 5: Test Your Scripts

Before adding to Conky, test that your scripts work:

1. **Test each script:**
   ```bash
   ~/.config/conky/my_backup_free.sh
   ```
   
   You should see output like: `350.2/500.0GB` or `Not mounted`

2. **If you see "Not mounted" but the drive IS mounted:**
   - Check your configuration file for typos
   - Make sure the serial/model in your config matches exactly what `list_drive_info.sh` showed
   - Ensure there's a blank line at the end of `drive_mappings.conf`

##### Step 6: Add to Your Conky Configuration

1. **Open your Conky configuration:**
   ```bash
   nano ~/.config/conky/conky.conf
   ```

2. **Find where you want to display drive information**

3. **Replace old drive monitoring with the new scripts.**
   
   **Old way (what to look for):**
   ```lua
   ${fs_free /mnt/backup}
   ${fs_free_perc /mnt/backup}%
   ```
   
   **New way (what to replace it with):**
   ```lua
   ${execi 30 ~/.config/conky/my_backup_free.sh}
   ```
   
   The `30` means update every 30 seconds. You can change this number.

4. **Complete example for a Conky config section:**
   ```lua
   ${color gray}Storage:${color}
   Backup:  ${execi 30 ~/.config/conky/my_backup_free.sh}
   Storage: ${execi 30 ~/.config/conky/my_storage_free.sh}
   System:  ${execi 30 ~/.config/conky/system_drive_free.sh}
   ```

5. **Save your conky.conf** (Ctrl+O, Enter, Ctrl+X)

6. **Restart Conky to see the changes:**
   ```bash
   killall conky
   conky &
   ```

##### Common Issues and Solutions

**"Not mounted" when drive is mounted:**
- Double-check serial numbers match exactly
- Add a blank line at the end of drive_mappings.conf: `echo "" >> ~/.config/conky/drive_mappings.conf`
- Check if another program (like Timeshift) is using the drive

**"Permission denied" errors:**
- Make sure all scripts are executable: `chmod +x ~/.config/conky/*.sh`

**Script not found errors:**
- Check that you're using the full path in conky.conf: `~/.config/conky/script_name.sh`
- Verify the script exists: `ls ~/.config/conky/`

##### Quick Reference - File Locations

After setup, you'll have these files:
```
~/.config/conky/
├── find_drive_by_hardware.sh    # Main script (don't edit)
├── list_drive_info.sh          # Helper to show drive info
├── drive_mappings.conf         # YOUR drive configuration
├── my_backup_free.sh           # Script for drive 1
├── my_storage_free.sh          # Script for drive 2
└── system_drive_free.sh        # Script for drive 3
```

#### Advantages

- **Survives mount point changes**: Works regardless of where drives are mounted
- **Survives reformatting**: Serial numbers don't change when you format a drive
- **Works with temporary mounts**: Handles drives mounted by backup software like Timeshift
- **Easy to maintain**: Just update the config file when you add/remove drives

#### Troubleshooting

If a drive shows "Not mounted":
1. Check if the drive is actually mounted: `lsblk`
2. Verify the identifier in your config matches the actual hardware: `~/.config/conky/list_drive_info.sh`
3. Ensure there's a newline at the end of `drive_mappings.conf`
4. Check if the drive is being used by another process (like backup software)

### Conky Installer Script

This script is **optional** and separate from the main Conky installation. While building from source installs the Conky binary and necessary libraries, this script helps with setting up your personal Conky environment.

> **Credit:** This script was originally created by Erik Dubois as part of the [Aureola Conky collection](https://github.com/erikdubois/Aureola). It has been included in this fork as a helpful tool for setting up your Conky environment.

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

Save this as `~/.config/conky/install-conky.sh` and make it executable:
```bash
chmod +x ~/.config/conky/install-conky.sh
```

Here's the script content:

<details>
<summary>install-conky.sh (click to expand)</summary>

```bash
#!/bin/bash
#
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. AT YOUR OWN RISK.
#
##################################################################################################################

# this little batch file will autostart conky
# and copy the configuration file to the standard place
# where conky looks for a configuration file
# Lua syntax!!

# killing whatever conkies are still working
echo "################################################################"
echo "Stopping conky's if available"

killall conky 2>/dev/null
sleep 1

##################################################################################################################
###################### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S            ######################
##################################################################################################################

# if there is no hidden folder autostart then make one
[ -d $HOME"/.config/autostart" ] || mkdir -p $HOME"/.config/autostart"

# if there is no hidden folder conky then make one
[ -d $HOME"/.config/conky" ] || mkdir -p $HOME"/.config/conky"

# if there is no hidden folder fonts then make one
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

##################################################################################################################
######################              C L E A N I N G  U P  O L D  F I L E S                    ####################
##################################################################################################################

# removing all the old files that may be in ./config/conky with confirm deletion

if [ "$(ls -A ~/.config/conky)" ] ; then
	echo "################################################################"
	read -p "Everything in folder ~/.config/conky will be deleted. Are you sure? (y/n)?" choice

	case "$choice" in 
 	 y|Y ) rm -r ~/.config/conky/*;;
 	 n|N ) echo "No files have been changed in folder ~/.config/conky." & echo "Script ended!" & exit;;
 	 * ) echo "Type y or n." & echo "Script ended!" & exit;;
	esac

else
	echo "################################################################" 
	echo "Installation folder is ready and empty. Files will now be copied."
fi

##################################################################################################################
######################              M O V I N G  I N  N E W  F I L E S                        ####################
##################################################################################################################

echo "################################################################" 
echo "The files have been copied to ~/.config/conky."
# the standard place conky looks for a config file
cp -r * ~/.config/conky/

echo "################################################################" 
echo "Making sure conky autostarts next boot."
# making sure conky is started at boot
cp start-conky.desktop ~/.config/autostart/start-conky.desktop

##################################################################################################################
########################                           F O N T S                            ##########################
##################################################################################################################

echo "################################################################" 
echo "Installing the fonts if you do not have it yet - with choice"

FONT="DejaVuSansMono"

if fc-list | grep -i $FONT >/dev/null ; then
	echo "################################################################" 
    echo "The font is already available. Proceeding ...";
else
	echo "################################################################" 
    echo "The font is not currently installed, would you like to install it now? (y/n)";
    read response
    if [[ "$response" == [yY] ]]; then
        echo "Installing the font to the ~/.fonts directory.";
        cp ~/.config/conky/fonts/* ~/.fonts
        echo "################################################################" 
        echo "Building new fonts into the cache files";
        echo "Depending on the number of fonts, this may take a while..." 
        fc-cache -fv ~/.fonts
		echo "################################################################" 
		echo "Check if the cache build was successful?";    
        if fc-list | grep -i $FONT >/dev/null; then
            echo "################################################################" 
            echo "The font was sucessfully installed!";
        else
        	echo "################################################################" 
            echo "Something went wrong while trying to install the font.";
        fi
    else
    	echo "################################################################" 	
        echo "Skipping the installation of the font.";
        echo "Please note that this conky configuration will not work";
        echo "correctly without the font.";
    fi
fi

##################################################################################################################
########################                    D E P E N D A N C I E S                     ##########################
##################################################################################################################

echo "################################################################"
echo "Checking dependancies"

DISTRO=$(lsb_release -si)

echo "################################################################"
echo "You are working on " $DISTRO
echo "################################################################"

case $DISTRO in 
	LinuxMint|linuxmint|Ubuntu|ubuntu)
	# C O N K Y
		# check if conky is installed
		if ! location="$(type -p "conky")" || [ -z "conky" ]; then
			echo "################################################################"
			echo "installing conky for this script to work"
			echo "################################################################"
		  	sudo apt-get install conky-all
		  else
		  	echo "Conky was installed. Proceeding..."
		fi
	
	# L M S E N S O R S
		# The conky depends on lm-sensors to know the motherboard and manufacturer
		# check if lm-sensors is installed
		if ! location="$(type -p "sensors")" || [ -z "sensors" ]; then
			echo "################################################################"
			echo "installing lm-sensors for this script to work"
			echo "#################################################################"
		  	sudo apt-get install lm-sensors
		  else
		  	echo "lm-sensors was installed. Proceeding..."
		fi
		;;

	Arch)
		echo "You are using an arch machine"
		echo "For this conky to work fully"
		echo "you need to install the following packages"
		echo "- conky-lua"
		echo "- dmidecode"
		echo "- lm-sensors"
		;;

	*)
		echo "No dependancies installed."
		echo "No installation lines for your system."
		;;
esac

##################################################################################################################
########################                    S T A R T  O F  C O N K Y                   ##########################
##################################################################################################################

echo "################################################################"
echo "Starting the conky"
echo "################################################################"

#starting the conky 
conky -q -c ~/.config/conky/conky.conf

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
```
</details>

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

---

<div align="center">

**Created with ❤️ by [NeatCode Labs](https://neatcodelabs.com)**  
Visit us for more useful tools and projects!

[![Website](https://img.shields.io/badge/Website-neatcodelabs.com-blue?style=for-the-badge)](https://neatcodelabs.com)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Us-ff5e5b?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/neatcodelabs)

</div>
