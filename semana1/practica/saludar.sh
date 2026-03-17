#!/bin/bash
NOMBRE=$1
APELLIDO=$2
EDAD=$3

if [ -z "$NOMBRE" ]; then
    echo "Error: debes pasar un nombre"
    echo "Uso: ./saludar.sh <nombre> <apellido>"
    exit 1
fi

echo "Hola, $NOMBRE $APELLIDO"
echo "Tienes: $EDAD años de edad"
echo "Hoy es $(date '+%A, %d de %B')"
echo "El número de argumento recibidos es: $#"
