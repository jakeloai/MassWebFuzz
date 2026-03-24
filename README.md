# 🛡️ MassWebFuzz (MWF) v1.0
**The High-Velocity Multi-Target Fuzzing Engine for Web Vulnerability Analysts.**

Developed by: **JakeLo.AI** (Web Vuln Analyst)

---

## 📖 Description

**MassWebFuzz (MWF)** is a specialized automation wrapper for `ffuf` designed for large-scale reconnaissance in professional Bug Bounty programs and enterprise-level Penetration Testing. 

While standard fuzzing tools focus on a single domain, **MWF** allows you to process hundreds of URLs (with embedded `FUZZ` keywords) against a massive library of 6,000+ wordlists (SecLists) in a sequential, persistent, and organized manner.

---

## 🚀 Key Features

* **Global Execution**: Install once and run from any directory using the `mwf` command.
* **Multi-Wordlist Engine**: Map thousands of SecLists paths via a centralized configuration file located at `/etc/mwf/`.
* **Target Persistence**: Automatically generates unique report files for every URL. Results are appended, never overwritten, ensuring no data loss across 6,000+ wordlist runs.
* **Pro Match Codes**: Pre-configured with `-mc 200,204,301,302,307,401,403,405,500` to capture authentication bypasses, internal errors, and hidden redirects.
* **High-Sec UI**: Minimalist Red & White interface designed for professional monitoring.
* **Automated Sanitization**: Converts complex URLs into safe Linux filenames for organized reporting.

---

## 🛠️ Installation & Setup

### 1. Prerequisites
Ensure you are running **Kali Linux** with the following installed:
* **ffuf**: `sudo apt install ffuf -y`
* **SecLists**: `sudo apt install seclists -y`

### 2. Global Installation
To use **MWF** from any directory in your terminal:

1.  Grant execution rights to the installer:
    ```bash
    chmod +x install.sh mwf.sh
    ```
2.  Run the installer with sudo:
    ```bash
    sudo ./install.sh
    ```

### 3. Configure Your Global Wordlists
After installation, add your SecLists paths (one per line) to the global configuration file:
```bash
sudo nano /etc/mwf/mass_fuzz_wordlists.txt
```
**Example entries:**
```text
/usr/share/seclists/Pattern-Matching/malicious.txt
/usr/share/seclists/Pattern-Matching/repo-scan.txt
/usr/share/seclists/Pattern-Matching/errors.txt
```

---

## 🎯 Usage Guide

### Step 1: Prepare Your Targets
Create a `targets.txt` file. You must include the `FUZZ` keyword in the URL where you want the payloads to be injected.

**Example `targets.txt`:**
```text
https://api.client.com/v1/auth?debug=FUZZ
https://dev-internal.client.org/FUZZ
https://example.com/index.php?file=FUZZ&user=admin
```

### Step 2: Execute the Scan
Launch a scan from any project folder:
```bash
mwf targets.txt
```

### Step 3: Analyze Results
MWF will create a timestamped directory in your current path: `./mwf_results_YYYYMMDD_HHMMSS/`.
Inside this folder, you will find individual `.txt` reports for each target URL. All matches from all wordlists are consolidated into these files.

---

## 🛡️ Professional Methodology

As a **Web Vuln Analyst**, this tool is designed to help you find:
1.  **401/403 Bypasses**: Identify endpoints that require auth but might be misconfigured.
2.  **500 Errors**: Locate server-side crashes (SQLi, SSTI, RCE indicators).
3.  **30X Redirects**: Discover hidden administrative panels or backup directories.
4.  **405 Method Not Allowed**: Find endpoints that exist but require different HTTP verbs (POST/PUT).

---

## ⚠️ Disclaimer

**FOR AUTHORIZED TESTING ONLY.**
The developer, **JakeLo.AI**, is not responsible for any misuse or damage caused by this tool. Usage of MassWebFuzz for attacking targets without prior mutual consent is illegal. It is the end-user's responsibility to obey all applicable laws.
