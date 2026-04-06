
#!/bin/bash

echo "Organizando projeto!"

mkdir -p ../src ../tb ../include ../docs

# include (.vh)
for file in *.vh; do
    if [ -f "$file" ]; then
        echo "Movendo $file para ../include/"
        mv -n "$file" ../include/
    fi
done

# docs (.md, .txt)
for file in *.md *.txt; do
    if [ -f "$file" ]; then
        echo "Movendo $file para ../docs/"
        mv -n "$file" ../docs/
    fi
done

# Testbench
for file in *.v; do
    if [ -f "$file" ] && [[ "$file" == *_tb.v || "$file" == *test* || "$file" == *-tb.v ]]; then
        echo "Movendo $file para ../tb/"
        mv -n "$file" ../tb/
    fi
done

# resto dos .v
for file in *.v; do
    if [ -f "$file" ]; then
        echo "Movendo $file para ../src/"
        mv -n "$file" ../src/
    fi
done

echo "Organização concluída!"