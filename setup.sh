#!/usr/bin/env bash
set -euo pipefail

# Basic setup script for ddim-reimplementation
# Creates/activates a virtual environment, installs dependencies, and runs quick sanity checks.

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${PROJECT_ROOT}/.venv"
PYTHON_BIN="python3"

echo "[DDIM SETUP] Project root: ${PROJECT_ROOT}"

if ! command -v ${PYTHON_BIN} >/dev/null 2>&1; then
	echo "Python3 not found. Please install Python 3.9+." >&2
	exit 1
fi

PY_VERSION="$(${PYTHON_BIN} - <<'EOF'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
EOF
)"
echo "[DDIM SETUP] Detected Python ${PY_VERSION}"

if [ ! -d "${VENV_DIR}" ]; then
	echo "[DDIM SETUP] Creating virtual environment in ${VENV_DIR}"
	${PYTHON_BIN} -m venv "${VENV_DIR}"
else
	echo "[DDIM SETUP] Reusing existing virtual environment"
fi

source "${VENV_DIR}/bin/activate"
echo "[DDIM SETUP] Virtual environment activated. Python: $(which python)"

pip install --upgrade pip wheel setuptools >/dev/null
echo "[DDIM SETUP] Installing requirements"
pip install -r "${PROJECT_ROOT}/requirements.txt"

echo "[DDIM SETUP] Verifying core imports"
python - <<'EOF'
import torch, torchvision, numpy, yaml, scipy, sklearn, tqdm, requests
print("Core libraries imported successfully.")
print("Torch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
EOF

echo "[DDIM SETUP] Creating directories (logs/, outputs/, datasets/ if missing)"
mkdir -p "${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/outputs" "${PROJECT_ROOT}/datasets"

echo "[DDIM SETUP] Done. To activate the environment later run:"
echo "  source ${VENV_DIR}/bin/activate"

