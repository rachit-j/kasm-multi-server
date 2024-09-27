#!/bin/bash

# Function to display a progress bar for the 'sleep' command
sleep_progress_bar() {
    local duration=$1  # The total duration to sleep
    local columns=$(tput cols)  # Get the width of the terminal screen
    local bar_length=$((columns - 20))  # Set the bar length based on terminal width, reserving space for percentage and text
    local completed_char="#"
    local incomplete_char="-"
    local elapsed=0

    echo -ne "Progress: ["

    while [ $elapsed -lt $duration ]; do
        sleep 1
        elapsed=$((elapsed + 1))

        # Calculate the number of completed and incomplete segments
        local complete_segments=$((bar_length * elapsed / duration))
        local incomplete_segments=$((bar_length - complete_segments))

        # Create the progress bar string
        local bar=$(printf "%-${complete_segments}s" | tr " " "$completed_char")
        local spaces=$(printf "%-${incomplete_segments}s" | tr " " "$incomplete_char")

        # Display the progress bar
        printf "\rProgress: [%-${bar_length}s] %d%%" "${bar}${spaces}" $((elapsed * 100 / duration))
    done

    echo -e "]\nDone!"
}

# Run the dependencies script
chmod +x kasm_dependencies.sh
./kasm_dependencies.sh

# Run the deployment script
chmod +x kasm_aws_instances.sh
./kasm_aws_instances.sh

sleep_progress_bar 300

# Run the command execution script
chmod +x kasm_servers_tools.sh
./kasm_servers_tools.sh

# Run the update inventory script
chmod +x kasm_servers_info.sh
./kasm_servers_info.sh

# Run the playbook script
chmod +x kasm_servers_playbook.sh
./kasm_servers_playbook.sh
