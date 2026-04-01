# Abrir o arquivo netlist.v
set arquivo [open "netlist.v" r]

# Ler conteúdo
set conteudo [read $arquivo]

# Fechar arquivo
close $arquivo

# Contadores
set and2 [regexp -all {AND2} $conteudo]
set xor2 [regexp -all {XOR2} $conteudo]
set dff  [regexp -all {flipflop_D} $conteudo]

# Total
set total [expr {$and2 + $xor2 + $dff}]

# Mostrar relatório
puts "=== RELATÓRIO DE CÉLULAS ==="
puts "AND2: $and2 instâncias"
puts "XOR2: $xor2 instâncias"
puts "flipflop_D: $dff instâncias"
puts "TOTAL: $total instâncias"
