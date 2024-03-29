# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xc7a100ticsg324-1L [current_project]
#XC7A100T-2CSG324I
#set_property board_part digilentinc.com:arty-a7-35:part0:1.0 [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

read_ip ../source/ftdi_if/ftdi_ila/ftdi_ila.xci
read_ip ../source/ftdi_if/ftdi_if_fifo/ftdi_if_fifo.xci

reset_target all [get_files *.xci]
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

read_verilog -sv ../source/ftdi_if/ftdi_if.sv
read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc  
read_xdc ../source/pins.xdc  
set_property used_in_synthesis FALSE [get_files ../source/pins.xdc]


close_project


