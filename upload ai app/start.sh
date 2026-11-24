#!/usr/bin/env bash
cd "$(dirname "$0")/backend" || exit 1
[ -d .venv ] || python3 -m venv .venv
source .venv/bin/activate
pip install -q -r requirements.txt || exit 1
(sleep 3; (xdg-open http://localhost:8000 || open http://localhost:8000) >/dev/null 2>&1) &
echo "Running at http://localhost:8000 (Ctrl+C to stop)"
python -m uvicorn main:app --port 8000
