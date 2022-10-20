
create_clock -period 10.000 -name clk100 -waveform {0.000 8.333} [get_ports {clkin100}]


create_clock -period 16.666 -name ftdi_clk -waveform {0.000 8.333} [get_ports {ftdi_clk}]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ftdi_if_inst/fclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets -of [get_pins ftdi_if_inst/fclk_buf/O]]

set ftdi_in_maxdel 7.15
set ftdi_in_mindel 1.0
set_input_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_in_mindel [get_ports {ftdi_data[*]}]
set_input_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_in_maxdel [get_ports {ftdi_data[*]}]
                                                                                                              
set_input_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_in_mindel [get_ports {ftdi_txe_n}]
set_input_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_in_maxdel [get_ports {ftdi_txe_n}]
                                                                                                              
set_input_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_in_mindel [get_ports {ftdi_rxf_n}]
set_input_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_in_maxdel [get_ports {ftdi_rxf_n}]
                                                                                                              
                                                                                                              
                                                                                                              
set ftdi_out_maxdel  8.0
set ftdi_out_mindel  0.0
set_output_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_out_mindel [get_ports {ftdi_data[*]}]
set_output_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_out_maxdel [get_ports {ftdi_data[*]}]

set_output_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_out_mindel [get_ports {ftdi_wr_n}]
set_output_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_out_maxdel [get_ports {ftdi_wr_n}]

set_output_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_out_mindel [get_ports {ftdi_rd_n}]
set_output_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_out_maxdel [get_ports {ftdi_rd_n}]

set_output_delay -clock [get_clocks {ftdi_clk}] -min -add_delay $ftdi_out_mindel [get_ports {ftdi_oe_n}]
set_output_delay -clock [get_clocks {ftdi_clk}] -max -add_delay $ftdi_out_maxdel [get_ports {ftdi_oe_n}]



set_property IOB TRUE [get_ports {ftdi_data[*]}]
set_property IOB TRUE [get_ports {ftdi_wr_n}]
set_property IOB TRUE [get_ports {ftdi_rd_n}]
set_property IOB TRUE [get_ports {ftdi_oe_n}]
