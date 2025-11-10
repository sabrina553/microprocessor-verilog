`timescale 1ns / 1ps
module rom_tb;

  // Parameters

  //Ports
  reg clk;
  reg [4:0] romIn1;
  reg [4:0] romIn2;
  wire [31:0] romOut1;
  wire [31:0] romOut2;

  rom  rom_inst (
    .clk(clk),
    .romIn1(romIn1),
    .romIn2(romIn2),
    .romOut1(romOut1),
    .romOut2(romOut2)
  );
always #5  clk = ! clk;
    initial begin 
        clk = 0;
        #10 romIn1 = 5'b01010; //10 -> 40159
        #10 romIn2 = 5'b11010; //26 -> 45177
        
        $display("-------displaying romOut1-------");
        $display("\t %0d",romOut1);
        $display("\t %0d",romOut2);     
          
        #10 romIn1 = 5'b10000; //10 -> 40159
        #10 romIn2 = 5'b01101; //26 -> 45177
        
        #10 romIn1 = 5'b11111; //10 -> 40159
        #10 romIn2 = 5'b01101; //26 -> 45177
        
        $display("-------displaying romOut1-------");
        $display("\t %0d",romOut1);
        $display("\t %0d",romOut2);
    end
endmodule
