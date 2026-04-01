# Atividade Makefile

Este projeto demonstra o uso de um Makefile para automatizar a geração de um relatório a partir de scripts TCL e a organização de arquivos em uma estrutura de projeto.

## Estrutura do Projeto
.
├── Makefile # Makefile principal
├── organiza_projeto.sh # Script de organização
├── git-tcl/ # Pasta com os scripts TCL e netlist
│ ├── tarefa_1.tcl
│ ├── tarefa_2.tcl
│ ├── tarefa_3.tcl
│ ├── netlist/
│ │ └── netlist.v
│ └── netlist.v -> netlist/netlist.v
├── projeto/ # Pasta gerada pelo organizador (ignorada)
│ ├── src/ # Arquivos .v (que não são testbench)
│ ├── tb/ # Testbenches (tb.v ou test.v)
│ ├── include/ # Arquivos .vh
│ ├── scripts/ # Scripts .tcl, .do, .sh (exceto tarefa*.tcl)
│ └── docs/ # Documentação (.md, .txt)
└── README.md # Este arquivo

## Funcionamento

### Targets do Makefile

- **`make`** ou **`make all`**: 
  1. Gera o relatório final (`git-tcl/relatorio.txt`) executando os scripts TCL (`tarefa_1.tcl`, `tarefa_2.tcl`, `tarefa_3.tcl`) **apenas se ele não existir** ou se algum dos scripts ou `netlist.v` for modificado.
  2. Executa o script `organiza_projeto.sh` para mover os arquivos da raiz para a estrutura `projeto/` conforme as regras de classificação.

- **`make clean`**: Remove apenas o arquivo de relatório (`git-tcl/relatorio.txt`).

- **`make organizar`**: Executa apenas o organizador (útil se você já tem o relatório e quer organizar novamente).

### Regras de classificação do organizador

- `src/` → arquivos `.v` que **não** são testbench.
- `tb/` → arquivos com `_tb.v` ou que contenham `test` no nome.
- `include/` → arquivos `.vh`.
- `scripts/` → arquivos `.tcl` (exceto `tarefa_*.tcl`), `.do`, `.sh`.
- `docs/` → arquivos `.md`, `.txt`.

### Arquivos ignorados pelo organizador

- O próprio script `organiza_projeto.sh`
- Os scripts TCL usados na geração do relatório (`tarefa_*.tcl`)
- O link simbólico `netlist.v`
- O arquivo de relatório `relatorio.txt`
- A pasta `git-tcl/` (não é processada)

## Como usar

1. Coloque os arquivos que deseja organizar (`.v`, `.vh`, `.tcl`, etc.) no diretório raiz.
2. Execute `make`:
   - O relatório será gerado (se necessário) e a saída aparecerá no terminal.
   - Em seguida, os arquivos serão movidos para a estrutura `projeto/` conforme as regras.
3. Para regenerar o relatório após alterações, use `make clean` e depois `make`.

## Requisitos

- `tclsh` (interpretador TCL) instalado.
- Bash.

## Observações

- O relatório final (`relatorio.txt`) fica dentro da pasta `git-tcl/`, isolado da estrutura organizada.
- A pasta `projeto/` é gerada pelo organizador e é ignorada pelo Git (via `.gitignore`), pois contém arquivos que podem ser recriados.

## Autor

Luciano066
