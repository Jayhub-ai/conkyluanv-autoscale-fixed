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
${execi 2 /home/neo/.config/conky/cpu_temp_avg.sh} °C
```

**Benefits of using the average:**
- **More stable readings**: Package temperature can spike rapidly due to single-core loads
- **Realistic values**: Represents the typical CPU temperature across all cores
- **Less erratic display**: Smoother temperature changes in your Conky display

**Note:** The average will typically be lower than the package temperature since it represents the average across all cores rather than the hottest spot on the CPU package.

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
