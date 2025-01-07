#!/bin/bash

# Function to get CPU information
get_cpu_info() {
    echo "=== CPU Information ==="
    sysctl -n machdep.cpu.brand_string
    echo "Number of CPUs: $(sysctl -n hw.ncpu)"
    echo "Running CPU stress test..."
    yes > /dev/null & 
    pid=$!
    sleep 10
    kill $pid
}

# Function to get memory information and performance
get_memory_info() {
    echo -e "\n=== Memory Information ==="
    echo "Memory Statistics:"
    vm_stat
    top -l 1 -n 0 | grep PhysMem
}

# Function to test disk performance
test_disk_performance() {
    echo -e "\n=== Disk Performance ==="
    echo "Testing disk write speed..."
    dd if=/dev/zero of=./tempfile bs=1m count=1024 2>&1
    echo "Testing disk read speed..."
    dd if=./tempfile of=/dev/null bs=1m count=1024 2>&1
    rm ./tempfile
}

# Function to configure Ollama based on results
configure_ollama() {
    # Get total memory in GB
    local total_mem=$(sysctl hw.memsize | awk '{print int($2/1024/1024/1024)}')
    local cpu_threads=$(sysctl -n hw.ncpu)
    
    # Calculate optimal values
    local n_gpu=0
    if command -v nvidia-smi &> /dev/null; then
        n_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | wc -l)
    fi
    
    # Check for Apple Silicon
    local is_apple_silicon=false
    if [[ $(sysctl -n machdep.cpu.brand_string) == *"Apple"* ]]; then
        is_apple_silicon=true
    fi
    
    # Calculate memory limits (70% of available RAM)
    local mem_limit=$(( total_mem * 70 / 100 ))
    
    # Create Ollama directory if it doesn't exist
    mkdir -p ~/.ollama
    
    # Create or update Ollama configuration
    cat > ~/.ollama/config.json << EOF
{
    "runner": {
        "numThreads": $cpu_threads,
        "gpu": {
            "enabled": $([ "$is_apple_silicon" = true ] && echo "true" || echo "false"),
            "layers": -1
        },
        "memory": {
            "maxMemory": "${mem_limit}g"
        }
    }
}
EOF
}

# Main execution
echo "Starting system benchmark for Ollama optimization..."

# Run benchmarks
get_cpu_info
get_memory_info
test_disk_performance

# Configure Ollama
configure_ollama

echo -e "\n=== Configuration Complete ==="
echo "Ollama has been configured based on your system's capabilities."
echo "Configuration file created at ~/.ollama/config.json"
echo "Please restart Ollama to apply changes using:"
echo "brew services restart ollama"

# Display final configuration
echo -e "\nFinal configuration:"
cat ~/.ollama/config.json 

# Verify the configuration file
cat ~/.ollama/config.json

# Check Ollama service status
brew services list | grep ollama 