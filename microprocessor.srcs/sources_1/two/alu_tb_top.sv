`include "alu_pkg.sv"
`include "alu.v"
`include "alu_if.sv"

module alu_tb_top;
  import uvm_pkg::*;

  //interface declaration
  alu_if vif ();

  //connect interface to the DUT
  alu dut (
      vif.sig_clock,
      vif.sig_inA,
      vif.sig_inB,
      vif.sig_opcode,
      vif.sig_out
  );

  initial begin
    //registers the interface in the configuration block so that other blocks can use it
    uvm_resource_db#(virtual alu_if)::set(.scope("ifs"), .name("alu_if"), .val(vif));

    //execute the test
    run_test();
  end

  //variable initialisation
  initial begin
    vif.sig_clock <= 1'b0;
  end

  always #5 vif.sig_clock = ~vif.sig_clock;

endmodule
