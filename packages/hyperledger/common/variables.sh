
#!/bin/bash
set -e

BESU_PATH=${ENV_BESU_PATH:-"besu"}

DIR="$PWD"
DATA_DIR="$DIR/data"
BESU_DATA="$DATA_DIR/besu"
INPUT_DIR="$DIR/input"
OUT_DIR="$DIR/out"