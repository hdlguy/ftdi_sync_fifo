# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

read_ip ../ftdi_if/ftdi_if_fifo/ftdi_if_fifo.xci
read_ip ../ftdi_if/ftdi_clk_wiz/ftdi_clk_wiz.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]


read_verilog -sv ../ft2232hl.sv
read_verilog -sv ../ftdi_if/ftdi_if.sv
read_verilog -sv ../ftdi_if_tb.sv

add_files -fileset sim_1 -norecurse ./ftdi_if_tb_behav.wcfg

close_project

#########################



