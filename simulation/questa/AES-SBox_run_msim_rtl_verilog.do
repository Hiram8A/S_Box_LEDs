transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/HIM8A/Documents/1\ Maestria/Quartus_II_projects/Pract/S_Box_LEDs {C:/Users/HIM8A/Documents/1 Maestria/Quartus_II_projects/Pract/S_Box_LEDs/debouncer.v}
vlog -vlog01compat -work work +incdir+C:/Users/HIM8A/Documents/1\ Maestria/Quartus_II_projects/Pract/S_Box_LEDs {C:/Users/HIM8A/Documents/1 Maestria/Quartus_II_projects/Pract/S_Box_LEDs/AES_SBox.v}
vlog -vlog01compat -work work +incdir+C:/Users/HIM8A/Documents/1\ Maestria/Quartus_II_projects/Pract/S_Box_LEDs {C:/Users/HIM8A/Documents/1 Maestria/Quartus_II_projects/Pract/S_Box_LEDs/sbox_lookup.v}

vlog -vlog01compat -work work +incdir+C:/Users/HIM8A/Documents/1\ Maestria/Quartus_II_projects/Pract/S_Box_LEDs {C:/Users/HIM8A/Documents/1 Maestria/Quartus_II_projects/Pract/S_Box_LEDs/AES_SBox_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  AES_SBox_tb

add wave *
view structure
view signals
run -all
