`timescale 1ns / 1ps
module alu_tb;

  // Parameters

  //Ports
  reg clk;
  reg [31:0] inputA;
  reg [31:0] inputB;
  reg [5:0] opcode;
  wire [31:0] outputAlu;

  alu alu_inst (
      .clk(clk),
      .inputA(inputA),
      .inputB(inputB),
      .opcode(opcode),
      .outputAlu(outputAlu)
  );

  function static compare(int a, int b);
    if (a == b) begin
      return 1;
    end
  endfunction

  always #5 clk = !clk;
  initial begin
    clk = 0;
    #10;
    opcode = 6'b000100;  // Addition
    inputA = 32'hFF;  // 255
    inputB = 32'hFF;  //+255 = 510
    #10;
    inputA = 32'hbeef;  // 48879
    inputB = 32'hcafe;  //+51966 = 100845
    #10;
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
