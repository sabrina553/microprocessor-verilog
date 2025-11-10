`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sabrina
//
// Create Date: 11/10/2025 03:12:34 AM
// Design Name:
// Module Name: alu
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


module alu (
    // input
    input wire clk,
    input wire [31:0] inA,
    input wire [31:0] inB,
    input wire [5:0] opcode,
    //output
    output reg [31:0] out
);

  always @(posedge clk) begin
    case (opcode)
      6'b000100: out <= inA + inB;
      6'b001000: out <= inA - inB;
      //6'b001011: out <= abs(inA);
      6'b001010: out <= -inA;
      //6'b001110: out <= abs(inB); ignore absoulute for now :)
      6'b000110: out <= -inB;
      6'b000111: out <= inA | inB;
      6'b001001: out <= ~inA;
      6'b001111: out <= ~inB;
      6'b000010: out <= inA & inB;
      6'b000011: out <= inA ^ inB;
      default:   out <= 32'hFFFFFFFF;
    endcase
  end
endmodule
