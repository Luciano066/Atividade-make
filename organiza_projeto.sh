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

# Função para mover arquivos com segurança
mover() {
     origem="$1"
     destino="$2"

     for file in $origem; do
         [[ -e "$file" ]] || continue

         # Não mover o próprio script
         [[ "$file" == "organiza_projeto.sh" ]] && continue

         # Não mover os scripts TCL usados para o relatório
         [[ "$file" == tarefa_*.tcl ]] && continue

         # Não mover netlist.v (link ou arquivo)
         [[ "$file" == "netlist.v" ]] && continue

         # Não mover o relatório (opcional; comente se quiser movê-lo para docs/)
         [[ "$file" == "relatorio.txt" ]] && continue

         nome=$(basename "$file")

         # Se já existe no destino
         if [[ -e "$destino/$nome" ]]; then
             echo "[SKIP] já existe: $nome"
             continue
         fi

         echo "[MOVE] $nome para $destino/"
         $DRY_RUN || { mv -n "$file" "$destino/" && movidos=$((movidos+1)); }
     done
}

# Criar diretórios de destino dentro de projeto/
criar_dir projeto/src
criar_dir projeto/tb
criar_dir projeto/include
criar_dir projeto/scripts
criar_dir projeto/docs

# Regras de classificação

# 1. tb/ → arquivos com "_tb.v" no nome ou contendo "test"
mover "*_tb.v" projeto/tb
mover "*test*.v" projeto/tb

# 2. src/ → arquivos .v que não são testbench
for file in *.v; do
    # Pula se já foi movido como testbench
    [[ "$file" == *_tb.v || "$file" == *test* ]] && continue
    [[ -e "$file" ]] && mover "$file" projeto/src
done

# 3. include/ → .vh
mover "*.vh" projeto/include

# 4. scripts/ → .tcl, .do, .sh (exceto os tarefa_*.tcl e organiza_projeto.sh)
mover "*.tcl" projeto/scripts
mover "*.do" projeto/scripts
mover "*.sh" projeto/scripts

# 5. docs/ → .md, .txt (excluímos relatorio.txt acima, mas pode comentar se quiser movê-lo)
mover "*.md" projeto/docs
mover "*.txt" projeto/docs

echo "[OK] Organização concluída: $movidos arquivos movidos."
