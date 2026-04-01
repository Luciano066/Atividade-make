# Abrir e ler o netlist.v
set f [open "netlist.v" r]
set conteudo [read $f]
close $f

# Separar em linhas
set linhas [split $conteudo "\n"]

# Estruturas
set modulo_atual ""
set modulos {}
array set hierarquia {}
array set tem_primitiva {}

# Identificar módulos
foreach linha $linhas {
    if {[regexp {^module\s+(\w+)} $linha -> nome]} {
        set modulo_atual $nome
        lappend modulos $nome
        set hierarquia($nome) {}
        set tem_primitiva($nome) 0
    }
}

# Identificar instâncias
set modulo_atual ""

foreach linha $linhas {

    # detectar início de módulo
    if {[regexp {^module\s+(\w+)} $linha -> nome]} {
        set modulo_atual $nome
        continue
    }

    # detectar fim de módulo
    if {[regexp {^endmodule} $linha]} {
        set modulo_atual ""
        continue
    }

    # detectar instâncias
    if {$modulo_atual ne ""} {

        if {[regexp {^\s*(\w+)\s+\w+\s*\(} $linha -> tipo]} {

            # se for submódulo
            if {[lsearch $modulos $tipo] != -1} {
                lappend hierarquia($modulo_atual) $tipo
            } else {
                # é célula primitiva
                set tem_primitiva($modulo_atual) 1
            }
        }
    }
}

# Imprimir relatório
puts "=== HIERARQUIA DO DESIGN ===\n"

foreach mod [lsort $modulos] {

    puts $mod

    set subs $hierarquia($mod)

    # Caso 1: não tem nada
    if {[llength $subs] == 0 && !$tem_primitiva($mod)} {
        puts "  └── (módulo primitivo - sem submódulos)"
    } else {

        # Se tiver submódulos → agrupar
        if {[llength $subs] > 0} {

            array set contagem {}

            foreach sub $subs {
                if {![info exists contagem($sub)]} {
                    set contagem($sub) 0
                }
                incr contagem($sub)
            }

            foreach sub [array names contagem] {
                puts "  └── $sub ($contagem($sub) instâncias)"
            }
        }

        # Se tiver primitivas
        if {$tem_primitiva($mod)} {

            # Se não tem submódulos
            if {[llength $subs] == 0} {
                puts "  └── (apenas células primitivas)"
            } else {
                puts "  └── (células primitivas)"
            }
        }
    }

    puts ""
}
