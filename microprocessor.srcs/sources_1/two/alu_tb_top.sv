// `include "alu_pkg.sv"
`include "alu.sv"
`include "alu_if.sv"

module alu_tb_top;
  import uvm_pkg::*;

  //interface declaration
  alu_if vif ();

  //connect interface to the DUT
  alu dut (
      vif.sig_clock,
      vif.sig_ina
  );

endmodule
logic sig_clock;
logic sig_inA;
logic sig_inB;
logic sig_opcode;

logic sig_out;
