# 🌀 Mandelbrot Benchmark (Python)

## 📋 Overview
This benchmark generates a **Mandelbrot fractal** image using Python and measures performance across CPU cores.

It’s based on **The Computer Language Benchmarks Game** implementation by *Joerg Baumann* and uses `multiprocessing` to fully leverage modern CPUs.

## 🧠 Purpose
This benchmark tests:
- **Floating-point performance**
- **Complex number arithmetic**
- **Parallel CPU scaling efficiency**
- **Python interpreter overhead**

It outputs a **PBM (Portable Bitmap)** image that can be opened with `Preview` (macOS) or `ImageMagick`.

---

## ⚙️ Requirements

### macOS
Make sure Python 3 is installed:
```bash
python3 --version
```

If not, install it via Homebrew:
```bash
brew install python
```

---

## 🚀 Running the Benchmark

### 1. Run the Mandelbrot Generator
```bash
python3 mandelbrot.py 16000 > mandelbrot.pbm
```

This will generate a **16000 × 16000 pixel** Mandelbrot fractal and save it as `mandelbrot.pbm`.

> 💡 Larger sizes produce more precise results for performance testing.

---

## ⏱ Measuring Elapsed Time (macOS / Linux)

You can measure execution time using the built-in `time` command:
```bash
/usr/bin/time -l python3 mandelbrot.py 16000 > /dev/null
```

Example output:
```
        24.48 real         93.21 user          0.68 sys
  1234567896  maximum resident set size
```

- `real` → wall clock time (total elapsed)
- `user` → CPU time in user mode
- `sys` → CPU time in kernel mode
- `maximum resident set size` → peak memory usage in bytes

> ✅ `-l` (lowercase L) adds memory stats — macOS-specific enhancement to `/usr/bin/time`.

---

## 🧩 Notes

- Uses all available CPU cores (`multiprocessing.Pool`).
- Outputs PBM format (`P4`) → binary black/white image.
- The PBM file can be previewed directly:
  ```bash
  open mandelbrot.pbm
  ```

To save storage space when running multiple tests, redirect output to `/dev/null`:
```bash
python3 mandelbrot.py 16000 > /dev/null
```

---

## 📊 Advanced Benchmarking with Hyperfine (macOS)

For more precise benchmarking with statistical analysis, use **hyperfine**:

Install hyperfine via Homebrew:
```bash
brew install hyperfine
```

Run the benchmark with warmup and multiple iterations:
```bash
hyperfine -w 1 -r 6 "python3 main.py 16000 > /dev/null" --show-output
```

Example output:
```
Benchmark 1: python3 main.py 16000 > /dev/null
  Time (mean ± σ):     24.057 s ±  1.688 s    [User: 342.335 s, System: 3.397 s]
  Range (min … max):   22.236 s … 26.922 s    6 runs
```

- `mean ± σ` → average time with standard deviation
- `User` → total CPU time across all cores in user mode
- `System` → total CPU time in kernel mode
- `Range` → fastest and slowest run times

> 💡 The `-w 1` flag runs 1 warmup iteration, and `-r 6` runs 6 measured iterations for statistical reliability.

---

## 🧰 Optional: Python-based Timing

You can also measure time directly inside Python using:
```bash
python3 -m timeit -n 1 -r 1 -s "import mandelbrot" "mandelbrot.mandelbrot(16000)"
```
This isolates the pure Python execution time without shell overhead.

---

## 📈 Example Benchmark Results (Apple M2 Ultra)
| Resolution | Cores | Time (s) | Memory (MB) |
|-------------|--------|----------|--------------|
| 1000×1000   | 16     | 0.4      | 40           |
| 4000×4000   | 16     | 3.2      | 90           |
| 16000×16000 | 16     | 24.4     | 310          |

*(Example numbers for reference, based on the YouTube benchmark result)*

---

## 🧾 License
This benchmark is based on:
> [The Computer Language Benchmarks Game – Python 3 Mandelbrot #7](https://salsa.debian.org/benchmarksgame-team/benchmarksgame)

---

## 📂 Folder Structure

```
benchmarks/
└── mandelbrot/
    ├── mandelbrot.py
    ├── README.md
    └── results/
        └── macstudio_mandelbrot_2025-10-29.txt
```
