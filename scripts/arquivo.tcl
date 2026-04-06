puts "ola mundo - entre aspas";
puts {ola mundo - entre chaves}
puts olaMundo

# -----------------------------------------
# atividade 1 - TCL
# -----------------------------------------

set arquivo "contador_netlist.v"
set palavras {"AND2" "XOR2" "flipflop_D"}
array set contadores {}
set soma_total 0

foreach palavra $palavras {
    set contadores($palavra) 0
}

set file [open $arquivo r]

while {[gets $file line] >= 0 } {
    foreach palavra $palavras {
        set pos 0
        while {[set indice [string first $palavra $line $pos]] != -1} {
            incr contadores($palavra)
            set pos [expr {$indice + [string length $palavra]}]
        }
    }
}

close $file

puts "=== RELATORIO DE CELULAS ==="
foreach palavra $palavras {
    puts "$palavra: $contadores($palavra)"
    set soma_total [expr {$soma_total + $contadores($palavra)}]
}
puts "TOTAL: $soma_total"

# -----------------------------------------
# Atividade 2 - TCL
# -----------------------------------------

# CORREÇÃO AQUI 👇
if {$argc == 0} {
    set filename "contador_netlist.v"
} else {
    set filename [lindex $argv 0]
}

if {[catch {set fp [open $filename r]} errmsg]} {
    puts "Erro ao abrir o arquivo: $errmsg"
    exit 1
}

set content [read $fp]
close $fp
set lines [split $content "\n"]

set known_modules [list]

foreach line $lines {
    if {[regexp {\s*module\s+([a-zA-Z0-9_]+)} $line -> mod_name]} {
        lappend known_modules $mod_name
    }
}

set hierarchy [dict create]
set has_primitives [dict create]
set current_module ""

foreach mod $known_modules {
    dict set hierarchy $mod [dict create]
    dict set has_primitives $mod 0
}

foreach line $lines {
    if {[regexp {^\s*module\s+([a-zA-Z0-9_]+)} $line -> mod_name]} {
        set current_module $mod_name

    } elseif {[regexp {^\s*endmodule} $line]} {
        set current_module ""

    } elseif {$current_module ne ""} {

        if {[regexp {^\s*//} $line] || [regexp {^\s*$} $line]} { continue }

        if {[regexp {^\s*([a-zA-Z0-9_]+)\s+[a-zA-Z0-9_]+\s*\(} $line -> inst_type]} {

            if {$inst_type in $known_modules } {

                if {[dict exists $hierarchy $current_module $inst_type]} {
                    set count [dict get $hierarchy $current_module $inst_type]
                } else {
                    set count 0
                }

                incr count
                dict set hierarchy $current_module $inst_type $count

            } else {
                set keywords {always if else assign module input output wire reg endmodule}

                if {$inst_type ni $keywords} {
                    dict set has_primitives $current_module 1
                }
            }
        }
    }
}

puts "\n=== HIERARQUIA DO DESIGN ==="

foreach mod $known_modules {
    puts "\n$mod"

    set submods [dict get $hierarchy $mod]
    set num_submods [dict size $submods]
    set prims [dict get $has_primitives $mod]

    if {$num_submods == 0 && $prims == 0} {
        puts "  └── (módulo primitivo - sem submódulos)"

    } elseif {$num_submods == 0 && $prims == 1} {
        puts "  └── (apenas células primitivas)"

    } else {
        set keys [dict keys $submods]
        set total_submods [llength $keys]
        set i 0

        dict for {submod count} $submods {

            set inst_str [expr {$count == 1 ? "1 instância" : "$count instâncias"}]

            if {$prims == 0 && $i == ($total_submods - 1)} {
                puts "  └── $submod ($inst_str)"
            } else {
                puts "  ├── $submod ($inst_str)"
            }
            incr i
        }

        if {$prims == 1} {
            puts "  └── (células primitivas)"
        }
    }
}

# -----------------------------------------
# atividade 3 - FANOUT
# -----------------------------------------

# CORREÇÃO AQUI 👇
set arquivo "contador_netlist.v"

array set fanout {}
set output_pins {y Y Q}

set file [open $arquivo r]

while {[gets $file line] >= 0} {

    set matches [regexp -all -inline {\.([A-Za-z0-9_]+)\(([^)]+)\)} $line]

    if {[llength $matches] == 0} {
        continue
    }

    set pares {}
    foreach {full pino net} $matches {
        lappend pares [list $pino $net]
    }

    set entradas {}
    set saidas {}

    foreach par $pares {
        set pino [lindex $par 0]
        set net  [lindex $par 1]

        if {[lsearch -exact $output_pins $pino] != -1} {
            lappend saidas $net
        } else {
            lappend entradas $net
        }
    }

    foreach net $saidas {
        if {![info exists fanout($net)]} {
            set fanout($net) 0
        }
    }

    foreach net $entradas {

        if {[regexp {^[0-9]+'[bhd][0-9a-fA-F]+$} $net]} {
            continue
        }

        if {![info exists fanout($net)]} {
            set fanout($net) 0
        }

        incr fanout($net)
    }
}

close $file

puts "\n=== FANOUT POR NET ==="

set lista {}
foreach net [array names fanout] {
    lappend lista [list $net $fanout($net)]
}

set ordenado [lsort -decreasing -integer -index 1 $lista]

puts "\n=== TOP 15 FANOUT ==="
foreach item [lrange $ordenado 0 14] {
    puts "[lindex $item 0]: [lindex $item 1]"
}

puts "\n=== FANOUT ZERO ==="
foreach net [array names fanout] {
    if {$fanout($net) == 0} {
        puts $net
    }
}