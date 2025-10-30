# LLM Benchmark with llama-bench# LLM Benchmark with llama-bench# LLM Benchmark with llama-bench



Simple benchmarking setup for testing LLM inference performance using `llama-bench`.



## PrerequisitesSimple benchmarking setup for testing LLM inference performance using `llama-bench`.Simple benchmarking setup for testing LLM inference performance using `llama-bench`.



- **llama-bench**: Install from [llama.cpp](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)



## Examples## Quick Start---



### Option 1: Use the automated script

```bash

./run_llama_bench.sh### Option 1: Use the automated script## ✅ What this measures

```

```bash

### Option 2: Manual with Hugging Face CLI + llama-bench

```bash./run_llama_bench.sh- **t/s** (tokens per second) for **prefill** and **decode** phases

# Download model

huggingface-cli download --local-dir ./models deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf```- Effect of **context length**, **batch size**, **GPU vs CPU** backends



# Run benchmark- Impact of **quantization** (e.g., Q4_K_M, Q5_K_M, Q8_0, FP16)

llama-bench --model ./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf

```This script will:- Threading (`--threads`), GPU layers (`--ngl`), and KV cache type



## Model- Download the model from Hugging Face if it doesn't exist



Currently configured for:- Run llama-bench with the model`llama-bench` runs a synthetic prompt; use `main` for end‑to‑end chat latency if needed.

- **Model**: DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf

- **Source**: deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF

### Option 2: Manual command---

```bash

llama-bench --model ./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf## 📦 Prerequisites

```

### macOS (Apple Silicon)

## Model- Xcode Command Line Tools

- CMake ≥ 3.24

Currently configured for:- Python 3 (optional for helper scripts)

- **Model**: DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf- **Metal** backend is built in by default

- **Source**: deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF- llama-bench [https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md]



## Directory Structure---

```

llm/## 📥 Get a model

├── models/

│   └── DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.ggufYou need a **GGUF** model file. Example (DeepSeek‑R1‑Distill‑Qwen‑7B in Q4_K_M):

├── run_llama_bench.sh

└── README_llama_bench.md```bash

```# With Hugging Face CLI (optional; or download manually)
pipx install huggingface_hub || pip install --user huggingface_hub
huggingface-cli download --local-dir ./models   lmstudio-community/DeepSeek-R1-Distill-Qwen-7B-GGUF   DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
```
huggingface-cli download --local-dir ./models   lmstudio-community/DeepSeek-R1-Distill-Qwen-7B-GGUF   DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf

Directory structure:
```
benchmarks/
└── llm/
    ├── models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
    ├── run.sh
    └── README.md  <-- this file
```

> You can benchmark multiple quantizations (Q2_K, Q3_K_S, Q4_K_M, Q5_K_M, Q8_0, F16). Larger files generally ⇒ higher quality and lower speed.

---

## 🚀 Quick start (macOS / Metal)

```bash
MODEL=./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
build/bin/llama-bench   -m "$MODEL"   --n-prompt 2048   --n-gen 512   --batch-size 512   --threads $(sysctl -n hw.logicalcpu)   --ngl 9999   --warmup 1   --repeat 5   --json out.json
```

**Flags explained**

- `--n-prompt` : prefill tokens (context length)
- `--n-gen`    : tokens to generate (decode)
- `--batch-size` : micro-batch size for prefill (try 32..1024)
- `--threads`  : CPU threads for remaining layers / CPU path
- `--ngl`      : number of layers to offload to GPU (use 9999 = all)
- `--warmup`   : discard first run
- `--repeat`   : number of measured runs
- `--json`     : structured output for your suite

On macOS you should see Metal selected automatically. On Linux/Windows with multiple backends, prefer explicit builds per backend to avoid ambiguity.

---

## 🧾 Reading the results

The CLI prints a table like:
```
| model | size | params | backend | ngl | test | t/s |
|------ |----- |------- |-------- |---- |----- |---- |
...
```
The JSON file contains full metadata (system, backend, batch, timings). Store it alongside your suite’s CSV/JSON.

To extract a compact CSV:
```bash
python3 - <<'PY'
import json, csv, sys
j = json.load(open("out.json"))
rows = []
for r in j["results"]:
  rows.append({
    "model": j["model_name"],
    "backend": j.get("backend","metal"),
    "ngl": r.get("ngl"),
    "n_prompt": r.get("n_prompt"),
    "n_gen": r.get("n_gen"),
    "batch": r.get("batch_size"),
    "tps_decode": r["tokens_per_second"]["decode"],
    "tps_prefill": r["tokens_per_second"]["prefill"],
    "time_ms_total": r["timings_ms"]["total"],
  })
w = csv.DictWriter(sys.stdout, fieldnames=rows[0].keys())
w.writeheader(); w.writerows(rows)
PY
```

---

## 🔁 Compare settings quickly (Hyperfine)

```bash
brew install hyperfine

MODEL=./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
hyperfine -w 1 -r 5   "build/bin/llama-bench -m $MODEL --n-prompt 2048 --n-gen 512 --batch-size 256 --ngl 9999"   "build/bin/llama-bench -m $MODEL --n-prompt 2048 --n-gen 512 --batch-size 512 --ngl 9999"   "build/bin/llama-bench -m $MODEL --n-prompt 4096 --n-gen 512 --batch-size 512 --ngl 9999"
```

Export:
```bash
hyperfine -w 1 -r 10 "build/bin/llama-bench -m $MODEL --n-prompt 2048 --n-gen 512 --batch-size 512 --ngl 9999"   --export-csv llama_bench_results.csv
```

---

## 🧪 End‑to‑end chat latency (optional)

For a “real prompt” test, use `main`:
```bash
PROMPT="Explain quantum entanglement in 2 sentences."
build/bin/main -m "$MODEL" -p "$PROMPT" --n-gpu-layers 9999 --temp 0.7 --threads $(sysctl -n hw.logicalcpu)
```
Measure with `/usr/bin/time -l` on macOS:
```bash
/usr/bin/time -l build/bin/main -m "$MODEL" -p "$PROMPT" > /dev/null
```

---

## 🧷 Reproducibility checklist

- Record:
  - model repo + **exact GGUF file name**
  - `llama.cpp` git commit
  - OS version, CPU model, RAM
  - GPU (e.g., M2 Ultra 60‑core) and backend (Metal/CUDA/Vulkan)
  - Flags: `--n-prompt`, `--n-gen`, `--batch-size`, `--threads`, `--ngl`
- Pin power/thermal settings (avoid background load)
- Run at least 5 repeats; report **median** and **p95**

---

## 🧯 Troubleshooting

- **OOM / VRAM**: decrease `--batch-size`, `--n-prompt`, or `--ngl`; choose a smaller quantization (e.g., Q4_K_M → Q3_K_S).
- **CPU selected instead of GPU**:
  - macOS: ensure `LLAMA_METAL=1` at build; check that `build/bin/llama-bench --list-devices` shows your Apple GPU.
  - Linux/Windows: build with the right backend define (`LLAMA_CUDA=1` or `LLAMA_VULKAN=1`).
- **Slow t/s**: verify `--ngl 9999`, increase batch size, use higher-precision quant only if quality matters.

---

## 📂 Suggested repo layout

```
benchmarks/
└── llm/
    ├── models/
    │   └── <model>.gguf
    ├── scripts/
    │   ├── bench_llama.sh
    │   └── parse_json.py
    └── README.md
```

**scripts/bench_llama.sh** (example):

```bash
#!/usr/bin/env bash
set -euo pipefail
MODEL="${1:-./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf}"
NP="${2:-2048}"
NG="${3:-512}"
BATCH="${4:-512}"
REPEAT="${5:-5}"
OUT="${6:-results_$(date +%Y-%m-%d_%H-%M).json}"
mkdir -p results
build/bin/llama-bench -m "$MODEL" --n-prompt "$NP" --n-gen "$NG"   --batch-size "$BATCH" --threads "$(sysctl -n hw.logicalcpu)"   --ngl 9999 --warmup 1 --repeat "$REPEAT" --json "results/$OUT"
echo "Saved results/$OUT"
```

Make executable:
```bash
chmod +x scripts/bench_llama.sh
```

---

## 📝 License & Credits

- **llama.cpp** by Georgi Gerganov and contributors (MIT)
- This README is part of your internal benchmarking suite.
