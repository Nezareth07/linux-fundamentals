# Linux Fundamentals — Week 1

Practice scripts and exercises from my DevOps learning path.

## Scripts

### `monitor.sh`
System resource monitor that tracks CPU, RAM and disk usage.
Triggers a `WARN` alert when any resource exceeds 80%.
Saves every report to a timestamped log file.

**Usage:**
```bash
chmod +x scripts/monitor.sh
./scripts/monitor.sh
```

**Output example:**
```
============================================
  SYSTEM MONITOR — 2026-03-16 09:14:22
============================================
  CPU              12%          [ OK ]
  RAM              512MB / 7700MB (6%)    [ OK ]
  Disk /           5.2G / 251G (2%)    [ OK ]
============================================
```

## Structure
```
semana1/
├── scripts/
│   ├── monitor.sh        # system monitor with alerts
│   └── sistema_info.sh   # basic system info reporter
└── logs/                 # auto-generated report logs
```

## Stack
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
