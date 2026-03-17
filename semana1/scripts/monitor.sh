#!/bin/bash

#--- configuración----------------------------------------------
UMBRAL=80
LOG_DIR=~/proyectos/semana1/logs
FECHA=$(date '+%Y-%m-%d')
HORA=$(date '+%H:%M:%S')
LOG_FILE="$LOG_DIR/sistema_${FECHA}.log"

#--- crear carpeta de logs si no existe ------------------------
mkdir -p "$LOG_DIR"

#--- funciones -------------------------------------------------
obtener_cpu() {
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "${cpu%.*}"   #quita decimales
}

obtener_ram(){
    total=$(free -m | awk '/Mem:/ {print $2}')
    usado=$(free -m | awk '/Mem:/ {print $3}')
    pct=$(( usado * 100 / total ))
    echo "$usado $total $pct"
}

obtener_disco() {
    pct=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    usado=$(df -h / | awk 'NR==2 {print $3}')
    total=$(df -h / | awk 'NR==2 {print $2}')
    echo "$usado $total $pct"
}

alerta() {
    local valor=$1
    local umbral=$2
    if [ "$valor" -gt "$umbral" ]; then
        echo "WARN"
    else
        echo " OK "
    fi
}

obtener_red() {
    local interfaz=$(ip route | awk 'NR==1 {print $5}')
    local ip=$(hostname -I | awk '{print $1}')
    local conexiones=$(ss -t | grep ESTAB | wc -l)
    echo "$interfaz $ip $conexiones"
}

# ── recolectar métricas ────────────────────────────────────
CPU=$(obtener_cpu)
read RAM_USADO RAM_TOTAL RAM_PCT <<< $(obtener_ram)
read DISCO_USADO DISCO_TOTAL DISCO_PCT <<< $(obtener_disco)
UPTIME=$(uptime -p)
read NET_INTERFAZ NET_IP NET_CONEXIONES <<< $(obtener_red)

# ── construir reporte ──────────────────────────────────────
REPORTE="
============================================
  SYSTEM MONITOR — $FECHA $HORA
============================================
  Host:    $(hostname)
  User:    $(whoami)
  Uptime:  $UPTIME

  RESOURCE         USAGE        STATUS
  ─────────────────────────────────────────
  CPU              ${CPU}%          [$(alerta $CPU $UMBRAL)]
  RAM              ${RAM_USADO}MB / ${RAM_TOTAL}MB (${RAM_PCT}%)    [$(alerta $RAM_PCT $UMBRAL)]
  Disk /           ${DISCO_USADO} / ${DISCO_TOTAL} (${DISCO_PCT}%)    [$(alerta $DISCO_PCT $UMBRAL)]
  Network          $NET_IP ($NET_INTERFAZ)
  Connections      $NET_CONEXIONES established
============================================
"

# ── mostrar en pantalla ────────────────────────────────────
echo "$REPORTE"

# ── guardar en log ─────────────────────────────────────────
echo "$REPORTE" >> "$LOG_FILE"
echo "Log saved: $LOG_FILE"
