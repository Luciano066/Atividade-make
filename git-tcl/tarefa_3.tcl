# Ler arquivo
set f [open "netlist.v" r]
set conteudo [read $f]
close $f

set linhas [split $conteudo "\n"]

# Dicionário de fanout
array set fanout {}

# Percorrer linhas
foreach linha $linhas {

    # Capturar conteúdo dentro dos parênteses
    if {[regexp {\((.*)\)} $linha -> dentro]} {

        # Separar os pares .pin(net)
        set sinais [split $dentro ","]

        # Extrair o nome da net de cada .pin(net)
        set nets {}
        foreach s $sinais {
            # Remove espaços extras
            set s [string trim $s]
            # Extrai o nome da net: .pin(net) -> net
            if {[regexp {\.\w+\(([^)]+)\)} $s -> net_name]} {
                lappend nets $net_name
            }
        }

        # Considera que o último elemento da lista é a saída,
        # os anteriores são entradas (entradas para fanout)
        if {[llength $nets] >= 1} {
            # Entradas: todos exceto o último
            set entradas [lrange $nets 0 end-1]
            foreach net $entradas {
                if {![info exists fanout($net)]} {
                    set fanout($net) 0
                }
                incr fanout($net)
            }

            # Saída: garante que exista no dicionário (para listar fanout zero)
            set saida [lindex $nets end]
            if {![info exists fanout($saida)]} {
                set fanout($saida) 0
            }
        }
    }
}

# Converter para lista ordenável
set lista {}
foreach net [array names fanout] {
    lappend lista [list $fanout($net) $net]
}

# Ordenar por fanout (decrescente)
set lista_ordenada [lsort -integer -decreasing -index 0 $lista]

# Top 10
puts "=== TOP 10 NETS POR FANOUT ==="
set i 0
foreach item $lista_ordenada {
    if {$i >= 10} break
    set valor [lindex $item 0]
    set nome [lindex $item 1]
    puts "$nome: fanout = $valor"
    incr i
}
puts ""

# Nets com fanout zero (possíveis erros)
puts "=== NETS COM FANOUT ZERO (POSSÍVEIS ERROS) ==="
foreach net [array names fanout] {
    if {$fanout($net) == 0} {
        puts $net
    }
}
