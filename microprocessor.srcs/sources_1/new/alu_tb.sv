module alu_tb;

    // Parameters

    //Ports
    reg  clk;
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

    always #5  clk = ! clk;
    initial
        begin
            clk = 0;

            



        end


endmodule


// 	in1 <= X"0001ffff", X"0FAFffff" after 20 ns, X"F000ffff" after 40ns;
// 	in2 <= X"0100ffff", X"7FFFffff" after 10ns, X"FFFFffff" after 30ns;
// 	in3 <= "101000";
