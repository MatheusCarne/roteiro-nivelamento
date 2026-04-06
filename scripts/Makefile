
# Variáveis
TCL_SCRIPT = arquivo.tcl
SHELL_SCRIPT = meu-script.sh
RELATORIO = relatorio_final.txt

# Target principal
all: $(RELATORIO)

#Regra principal
$(RELATORIO):
	tclsh $(TCL_SCRIPT) > $(RELATORIO)
	bash $(SHELL_SCRIPT)

# Organização separada
organizar:
	bash $(SHELL_SCRIPT)

# Limpar
clean:
	rm -f $(RELATORIO)


