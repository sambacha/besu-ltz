
#!/bin/bash
set -e
source common/variables
source common/functions

# Start Besu
echo "Starting Besu."
runBesu "$1"