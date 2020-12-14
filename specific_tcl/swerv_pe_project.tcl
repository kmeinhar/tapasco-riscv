# Create instance: swerv_0, and set properties
  set swerv_0 [ create_bd_cell -type ip -vlnv [dict get $cpu_vlnv $project_name] swerv_0 ]
  set cpu_clk [get_bd_pins swerv_0/clk]

  # Create interface connections
  connect_bd_intf_net [get_bd_intf_pins axi_mem_intercon_1/S00_AXI] [get_bd_intf_pins swerv_0/lsu_axi]
  set iaxi [get_bd_intf_pins swerv_0/ifu_axi]
  
  # Create port connections
  connect_bd_net [get_bd_pins RVController_0/rv_rstn] [get_bd_pins swerv_0/rst_n]

proc create_specific_addr_segs {} {
  variable lmem
  # Create specific address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x11000000 [get_bd_addr_spaces swerv_0/lsu_axi] [get_bd_addr_segs RVController_0/saxi/reg0] SEG_RVController_0_reg0
  create_bd_addr_seg -range $lmem -offset $lmem [get_bd_addr_spaces swerv_0/lsu_axi] [get_bd_addr_segs rv_dmem_ctrl/S_AXI/Mem0] SEG_rv_dmem_ctrl_Mem0
  create_bd_addr_seg -range $lmem -offset 0x00000000 [get_bd_addr_spaces swerv_0/ifu_axi] [get_bd_addr_segs rv_imem_ctrl/S_AXI/Mem0] SEG_rv_imem_ctrl_Mem0

  # Insert JTAG interface port and connect it to the core
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:jtag_rtl:2.0 CoreJTAG
  connect_bd_intf_net [get_bd_intf_ports CoreJTAG] [get_bd_intf_pins swerv_0/jtag]

  create_bd_port -dir I JTAG_RST
  connect_bd_net [get_bd_ports JTAG_RST] [get_bd_pins swerv_0/jtag_trst_n]
}

proc get_external_mem_addr_space {} {
  return [get_bd_addr_spaces swerv_0/lsu_axi]
}
