`timescale 1ns / 1ps
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


module alu(
    // input
    input wire clk,
    input wire [31:0] inputA,
    input wire [31:0] inputB,
    input wire [5:0] opcode,
    //output
    output reg [31:0] outputAlu);

    always @ (posedge clk) begin
        case(opcode)
            6'b000100: outputAlu <= inputA + inputB;
            6'b001000: outputAlu <= inputA - inputB;
            //6'b001011: outputAlu <= abs(inputA);
            6'b001010: outputAlu <= -inputA;
            //6'b001110: outputAlu <= abs(inputB); ignore absoulute for now :)
            6'b000110: outputAlu <= -inputB;
            6'b000111: outputAlu <= inputA | inputB;
            6'b001001: outputAlu <= ~inputA;
            6'b001111: outputAlu <= ~inputB;
            6'b000010: outputAlu <= inputA & inputB;
            6'b000011: outputAlu <= inputA ^ inputB;
            default: outputAlu <= 32'hFFFFFFFF;
        endcase
    end
endmodule
