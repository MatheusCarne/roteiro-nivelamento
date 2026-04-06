#!/bin/bash

echo "Organizando projeto!"

mkdir -p ../src ../tb ../include ../docs ../scripts

# include (.vh)
for file in ../*.vh; do
    if [ -f "$file" ]; then
        echo "Movendo $file para include/"
        mv -n "$file" ../include/
    fi
done

# scripts (.tcl, .do, .sh)
for file in ../*.tcl ../*.do ../*.sh; do
    if [ -f "$file" ]; then
        echo "Movendo $file para scripts/"
        mv -n "$file" ../scripts/
    fi
done

# docs (.md, .txt)
for file in ../*.md ../*.txt; do
    if [ -f "$file" ]; then
        echo "Movendo $file para docs/"
        mv -n "$file" ../docs/
    fi
done

# Testbench (.v com _tb ou test)
for file in ../*.v; do
    if [[ "$file" == *_tb.v || "$file" == *test* || "$file" == *-tb.v ]]; then
        echo "Movendo $file para tb/"
        mv -n "$file" ../tb/
    fi
done

# Arquivos restantes (.v → src)
for file in ../*.v; do
    if [ -f "$file" ]; then
        echo "Movendo $file para src/"
        mv -n "$file" ../src/
    fi
done

echo "Organização concluída!"