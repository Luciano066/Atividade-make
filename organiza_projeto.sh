#!/bin/bash

set -euo pipefail

DRY_RUN=false
movidos=0

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo " Modo DRY-RUN ativado (nenhum arquivo será movido)"
fi

# Função para criar pasta se não existir
criar_dir() {
    if [[ ! -d "$1" ]]; then
        echo "Criando diretório: $1"
        $DRY_RUN || mkdir -p "$1"
    fi
}

# Função para mover arquivos com segunrança
mover() {
     origem="$1"
     destino="$2"

     for file in $origem; do
         [[ -e "$file" ]] || continue

          #não mover o próprio script
          [[ "$file" == "organiza_projeto.sh" ]] && continue

          nome=$(basename "$file")

          # se já existe no destino
          if [[ -e "$destino/$nome" ]]; then
             echo "[SKIP] já existe: $nome"
             continue
          fi

          echo "[MOVE] $nome para $destino/"
          $DRY_RUN || { mv -n "$file" "$destino/" && ((movidos++)); }
     done
}
# Criar diretórios 
criar_dir src
criar_dir tb
criar_dir include
criar_dir scripts
criar_dir docs

# Regras 
mover "*_tb.v" tb
mover "*test*.v" tb

for file in *.v; do
    [[ "$file" == *_tb.v || "$file" == *test* ]] && continue
    [[ -e "$file" ]] && mover "$file" src
done

mover "*.vh" include
mover "*.tcl" scripts
mover "*.do" scripts
mover "*.sh" scripts
mover "*.md" docs
mover "*.txt" docs

echo "[OK] Organização concluída: $movidos"
