#!/bin/bash
# modified from http://ficate.com/blog/2012/10/15/battery-life-in-the-land-of-tmux/
HEART='♥'
total_slots=6
if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

battery_percentage="$(echo "$current_charge/$total_charge*100" | bc -l | cut -d '.' -f 1)"
charged_slots=$(echo "($battery_percentage*0.01*$total_slots)+1" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt $total_slots ]]; then
  charged_slots=$total_slos
fi

green_hearts=""
red_hearts=""
for i in `seq 1 $charged_slots`; do green_hearts="$green_hearts$HEART"; done
if [[ $charged_slots -lt $total_slots ]]; then
  for i in `seq 1 $(echo "$total_slots-$charged_slots" | bc)`; do red_hearts="$red_hearts$HEART"; done
fi
if [[ "$(echo "$battery_percentage<33" | bc -l)" -eq 1 ]]; then
  percentage_color='red'
elif [[ "$(echo "$battery_percentage<66" | bc -l)" -eq 1 ]]; then
  percentage_color='yellow'
else
  percentage_color='darkgreen'
fi
echo "%F{green}$green_hearts%f%F{red}$red_hearts%f %F{$percentage_color}($battery_percentage %%)%f"
