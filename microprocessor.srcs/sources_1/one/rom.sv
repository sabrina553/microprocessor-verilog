`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Sabrina
//
// Create Date: 11/09/2025 10:04:07 PM
// Design Name:
// Module Name: rom
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module rom (
    // input
    input wire clk,
    input wire [4:0] romIn1,
    input wire [4:0] romIn2,
    //output
    output reg [31:0] romOut1,
    output reg [31:0] romOut2
);

  //DATA TYPES
  int rom_array[32];
  assign rom_array = '{
          32'h00000,
          32'h11388,
          32'h0A6A2,
          32'h10645,
          32'h0658E,
          32'h0658E,
          32'h1527A,
          32'h0FAD3,
          32'h0DB03,
          32'h09CDF,
          32'h1105B,
          32'h070BD,
          32'h0E891,
          32'h083BE,
          32'h05D69,
          32'h14C5F,
          32'h05945,
          32'h119FF,
          32'h1571D,
          32'h013B2,
          32'h14B94,
          32'h0593A,
          32'h12D64,
          32'h043D3,
          32'h15500,
          32'h0B03D,
          32'h1639A,
          32'h11D3D,
          32'h0DC7C,
          32'h0D28C,
          32'h13444,
          32'h00000
      };

  always @(posedge clk) begin
    romOut1 <= rom_array[romIn1];
    romOut2 <= rom_array[romIn2];
  end
endmodule
