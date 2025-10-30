# LLM Benchmark with llama-bench

Simple benchmarking setup for testing LLM inference performance using `llama-bench`.

## Prerequisites

- **llama-bench**: Install from [llama.cpp](https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md)

## Quick Start

### Option 1: Use the automated script

```bash
./run_llama_bench.sh
```

### Option 2: Manual with Hugging Face CLI + llama-bench

```bash
# Install huggingface_hub first
pip install -U huggingface_hub

# Download model
huggingface-cli download --local-dir ./models deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf

# Run benchmark
llama-bench --model ./models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
```

This script will:
- Download the model from Hugging Face if it doesn't exist

## ✅ What this measures

- Impact of **quantization** (e.g., Q4_K_M, Q5_K_M, Q8_0, FP16)
- Threading (`--threads`), GPU layers (`--ngl`), and KV cache type

## Model



Currently configured for:

- **Model**: DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
- **Source**: deepseek-ai/DeepSeek-R1-Distill-Qwen-7B-GGUF

`llama-bench` runs a synthetic prompt; use `main` for end‑to‑end chat latency if needed.

---

## 📦 Prerequisites

### macOS (Apple Silicon)

- Xcode Command Line Tools
- CMake ≥ 3.24
- Python 3 (optional for helper scripts)
- **Metal** backend is built in by default
- llama-bench [https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md]

## Directory Structure

```
llm/
├── models/
│   └── DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
├── run_llama_bench.sh
└── README_llama_bench.md
```

---

## � Get a model

You need a **GGUF** model file. Example (DeepSeek‑R1‑Distill‑Qwen‑7B in Q4_K_M):

```bash
# Install huggingface_hub first
pip install -U huggingface_hub

# With Hugging Face CLI (or download manually)
huggingface-cli download --local-dir ./models lmstudio-community/DeepSeek-R1-Distill-Qwen-7B-GGUF DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
```

Directory structure:
```
benchmarks/
└── llm/
    ├── models/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf
    ├── run.sh
    └── README.md  <-- this file
```

> You can benchmark multiple quantizations (Q2_K, Q3_K_S, Q4_K_M, Q5_K_M, Q8_0, F16). Larger files generally ⇒ higher quality and lower speed.

## 📝 License & Credits

- **llama.cpp** by Georgi Gerganov and contributors (MIT)
- This README is part of your internal benchmarking suite.
