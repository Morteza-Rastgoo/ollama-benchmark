# Ollama Benchmark Tool

A system benchmarking and configuration tool for Ollama on macOS that automatically optimizes performance based on your hardware capabilities.

## Features

- 🖥️ CPU performance detection and configuration
- 🧠 Memory analysis and optimal allocation
- 💽 Disk I/O performance testing
- 🚀 Automatic Apple Silicon (M1/M2/M3) GPU detection
- ⚙️ Dynamic Ollama configuration generation
- 📊 Memory limit calculation (70% of available RAM)

## Prerequisites

- macOS operating system
- [Ollama](https://ollama.ai) installed
- [Homebrew](https://brew.sh) package manager

## Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ollama-benchmark.git
cd ollama-benchmark

# Make the script executable
chmod +x benchmark_ollama.sh
```

## Usage

1. Run the benchmark script:
```bash
./benchmark_ollama.sh
```

2. The script will automatically:
   - Test CPU performance
   - Analyze memory statistics
   - Measure disk I/O speeds
   - Create optimized Ollama configuration
   - Generate `~/.ollama/config.json`

3. Restart Ollama to apply changes:
```bash
brew services restart ollama
```

## Configuration Details

The script generates a configuration file at `~/.ollama/config.json` with these optimizations:

- CPU thread allocation based on system capabilities
- GPU enablement for Apple Silicon
- Memory limits calculated as 70% of available system RAM
- Optimal layer configuration for your hardware

Example configuration:
```json
{
    "runner": {
        "numThreads": 8,
        "gpu": {
            "enabled": true,
            "layers": -1
        },
        "memory": {
            "maxMemory": "16g"
        }
    }
}
```

## Benchmarking Details

The script performs several tests:

### CPU Testing
- Identifies processor type and core count
- Runs a stress test to verify stability
- Determines optimal thread count

### Memory Analysis
- Calculates total available RAM
- Analyzes memory usage patterns
- Sets safe memory limits for Ollama

### Disk Performance
- Tests read/write speeds
- Verifies I/O performance
- Ensures sufficient disk performance for model operations

## Troubleshooting

If you encounter issues:

1. Verify Ollama installation:
```bash
brew services list | grep ollama
```

2. Check configuration file:
```bash
cat ~/.ollama/config.json
```

3. Ensure proper permissions:
```bash
ls -l ~/.ollama/config.json
```

4. Common issues:
   - If Ollama fails to start: Check system resources
   - If performance is poor: Verify GPU detection
   - If configuration fails: Check write permissions

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Submit a pull request

## License

MIT License - feel free to use and modify for your needs.

## Support

If you find this tool helpful, please consider:
- Star the repository
- Report any issues
- Share with others who use Ollama

