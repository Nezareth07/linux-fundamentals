#!/bin/bash

# Función que verifica si un comando existe en el sistema
comando_existe() {
    local cmd=$1
    if command -v "$cmd" > /dev/null 2>&1; then
        echo "OK"
    else
        echo "NO ENCONTRADO"
    fi
}

# Función que evalúa un porcentaje contra un umbral
evaluar_umbral() {
    local valor=$1
    local umbral=$2
    local nombre=$3

    if [ "$valor" -gt "$umbral" ]; then
        echo "  WARN  $nombre está al ${valor}% — supera el umbral de ${umbral}%"
    elif [ "$valor" -gt $(( umbral - 10 )) ]; then
        echo "  ATENCIÓN  $nombre está al ${valor}% — acercándose al límite"
    else
        echo "  OK    $nombre está al ${valor}% — normal"
    fi
}

# ── programa principal ──────────────────────────
echo "=== Verificación de servicios ==="
echo ""

echo "Herramientas instaladas:"
echo "  git:    $(comando_existe git)"
echo "  docker: $(comando_existe docker)"
echo "  python3: $(comando_existe python3)"
echo ""

echo "Estado de recursos:"
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)
RAM=$(free -m | awk 'NR==2 {print int($3*100/$2)}')
DISCO=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

evaluar_umbral "$CPU" 80 "CPU"
evaluar_umbral "$RAM" 80 "RAM"
evaluar_umbral "$DISCO" 80 "Disco"
