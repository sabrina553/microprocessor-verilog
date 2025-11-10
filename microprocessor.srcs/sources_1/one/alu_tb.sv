`timescale 1ns / 10ps
module alu_tb;

  // Parameters
  integer counter_drv, counter_finish;
  //Ports
  reg clk;
  reg [31:0] inputA;
  reg [31:0] inputB;
  reg [5:0] opcode;
  wire [31:0] outputAlu;

  //Connect the DUT to the TB
  alu alu_inst (
      .clk(clk),
      .inputA(inputA),
      .inputB(inputB),
      .opcode(opcode),
      .outputAlu(outputAlu)
  );

  //instantiate all inputs (not outputs (wire)) 
  initial begin
    clk = 1'b0;
    inputA = 32'b0;
    inputB = 32'b0;
    opcode = 6'b0;

    counter_drv = 0;
    counter_finish = 0;
  end

  //generate clock cycle (after 20ns)
  initial begin
    forever #20 clk = !clk;
  end

  //Stops testbench after 30 clock cyles
  always @(posedge clk) begin
    counter_finish = counter_finish + 1;
    if (counter_finish == 20) $finish;
  end


  //driver 
  initial begin
    #40;
    opcode = 6'b000100;  // Addition
    inputA = 32'hFF;  // 255
    inputB = 32'hFF;  //+255 = 510
    #40;
    inputA = 32'hbeef;  // 48879
    inputB = 32'hcafe;  //+51966 = 100845
    #40;
    inputA = 32'hdead;  // 57005
    inputB = 32'haa55;  //+43605 = 100610
  end

  //monitors for change in variables as below (suppose the `$` excludes time)
  initial begin
    $monitor("Time=%0t \t %d=iA %d=iB %d=op %d=out", $time, inputA, inputB, opcode, outputAlu);
  end


endmodule


//in1 <= X"0001ffff", X"0FAFffff" after 20 ns, X"F000ffff" after 40ns;
//in2 <= X"0100ffff", X"7FFFffff" after 10ns, X"FFFFffff" after 30ns;
//in3 <= "101000";
