#!/bin/bash

echo "Organizando projeto!"

mkdir -p ../src ../tb ../include ../docs

# include (.vh)
mv ../*.vh ../include/ 2>/dev/null

# scripts (.tcl, .do, .sh)
mv ../*.tcl ../scripts/ 2>/dev/null
mv ../*.do ../scripts/ 2>/dev/null

# docs (.md, .txt)
mv ../*.md ../docs/ 2>/dev/null
mv ../*.txt ../docs/ 2>/dev/null

# Testbench (.v com _tb ou test)
for file in ../*.v; do
    if [[ "$file" == *_tb.v || "$file" == *test* || "$file" == *-tb.v ]]; then
        mv "$file" ../tb/
        echo "Movendo $file para tb/"
    fi
done

# Arquivos restantes (.v → src)
for file in ../*.v; do
    if [ -f "$file" ]; then
        mv "$file" ../src/
        echo "Movendo $file para src/"
    fi
done

echo "Organização concluída!"
