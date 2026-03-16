#!/bin/bash

# Variables - nota la sintaxis: sin espacios alrededor del =
USUARIO=$(whoami)
FECHA=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)

echo "========================================="
echo "   SISTEMA: $HOSTNAME"
echo "   USUARIO: $USUARIO"
echo "   FECHA:   $FECHA"
echo "========================================="
echo ""
echo "Directorio actual: $(pwd)"
echo "Uptime del sistema: $(uptime -p)"
echo ""
echo "Archivos en home:"
ls -la ~
