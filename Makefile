# Variáveis
TCL_DIR     = git-tcl
TCL_SCRIPTS = tarefa_1.tcl tarefa_2.tcl tarefa_3.tcl
RELATORIO   = $(TCL_DIR)/relatorio.txt
TCLSH       = tclsh
SHELL_SCRIPT = organiza_projeto.sh
BASH        = bash

# Target padrão: gera o relatório (dentro de git-tcl) e depois organiza
all: $(RELATORIO) organizar

# Gera o relatório apenas se não existir ou se os pré-requisitos mudarem
$(RELATORIO): $(addprefix $(TCL_DIR)/, $(TCL_SCRIPTS)) $(TCL_DIR)/netlist.v
	@echo "=== Gerando relatório em $(RELATORIO) ==="
	cd $(TCL_DIR) && > relatorio.txt
	cd $(TCL_DIR) && for script in $(TCL_SCRIPTS); do \
		echo "=== $$script ===" | tee -a relatorio.txt; \
		$(TCLSH) $$script 2>&1 | tee -a relatorio.txt; \
		echo "" | tee -a relatorio.txt; \
	done
	@echo "=== Relatório salvo ==="

# Executa o organizador (depende do relatório para garantir ordem)
organizar: $(RELATORIO)
	$(BASH) $(SHELL_SCRIPT)

# Limpeza: remove apenas o relatório (dentro de git-tcl)
clean:
	rm -f $(RELATORIO)

.PHONY: all organizar clean
