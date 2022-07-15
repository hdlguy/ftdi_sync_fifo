set_property IOSTANDARD LVCMOS25    [get_ports {clkin100}]; # Vadj is 2.5V
set_property PACKAGE_PIN F4         [get_ports {clkin100}]

set_property IOSTANDARD LVCMOS33    [get_ports {ftdi_*}]
set_property PACKAGE_PIN   A18      [get_ports {ftdi_data[0]}]
set_property PACKAGE_PIN   B18      [get_ports {ftdi_data[1]}]
set_property PACKAGE_PIN   D18      [get_ports {ftdi_data[2]}]
set_property PACKAGE_PIN   E18      [get_ports {ftdi_data[3]}]
set_property PACKAGE_PIN   F18      [get_ports {ftdi_data[4]}]
set_property PACKAGE_PIN   G18      [get_ports {ftdi_data[5]}]
set_property PACKAGE_PIN   J17      [get_ports {ftdi_data[6]}]
set_property PACKAGE_PIN   J18      [get_ports {ftdi_data[7]}]

set_property PACKAGE_PIN   G13      [get_ports {ftdi_rxf_n}]
set_property PACKAGE_PIN   K16      [get_ports {ftdi_txe_n}]
set_property PACKAGE_PIN    D9      [get_ports {ftdi_rd_n}]
set_property PACKAGE_PIN   M13      [get_ports {ftdi_wr_n}]
set_property PACKAGE_PIN   D10      [get_ports {ftdi_siwu_n}]
set_property PACKAGE_PIN   D15      [get_ports {ftdi_clk}]
set_property PACKAGE_PIN   C15      [get_ports {ftdi_oe_n}]
set_property PACKAGE_PIN   C17      [get_ports {ftdi_pwrsav_n}]

