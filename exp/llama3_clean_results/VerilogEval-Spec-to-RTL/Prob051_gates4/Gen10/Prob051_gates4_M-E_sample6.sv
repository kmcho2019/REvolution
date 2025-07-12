// Define the interface or base module for gates
module Gate(
    input [3:0] in,
    output out
);

endmodule

// Implement the 4-input AND gate using a LUT
module FourInputAND(
    input  [3:0] in,
    output out
);
    assign out = in[3] & in[2] & in[1] & in[0];
endmodule

// Implement the 4-input OR gate using a LUT
module FourInputOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] | in[2] | in[1] | in[0];
endmodule

// Implement the 2-input XOR gate using a LUT
module TwoInputXOR(
    input  a,
    input  b,
    output out
);
    assign out = a ^ b;
endmodule

// Implement the 4-input XOR gate using a tree-like structure of 2-input XOR gates
module FourInputXOR(
    input  [3:0] in,
    output out
);
    wire xor_0_1, xor_2_3;
    TwoInputXOR xorGate1(in[0], in[1], xor_0_1);
    TwoInputXOR xorGate2(in[2], in[3], xor_2_3);
    TwoInputXOR xorGate3(xor_0_1, xor_2_3, out);
endmodule

// Implement the pipelined AND gate
module PipelinedAND(
    input  [3:0] in,
    input  clk,
    input  rst_n,
    output out
);
    reg [3:0] and_reg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            and_reg <= 4'b0;
        end else begin
            and_reg <= in;
        end
    end
    assign out = and_reg[3] & and_reg[2] & and_reg[1] & and_reg[0];
endmodule

// Implement the pipelined OR gate
module PipelinedOR(
    input  [3:0] in,
    input  clk,
    input  rst_n,
    output out
);
    reg [3:0] or_reg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            or_reg <= 4'b0;
        end else begin
            or_reg <= in;
        end
    end
    assign out = or_reg[3] | or_reg[2] | or_reg[1] | or_reg[0];
endmodule

// Implement the pipelined XOR gate
module PipelinedXOR(
    input  [3:0] in,
    input  clk,
    input  rst_n,
    output out
);
    reg [3:0] xor_reg;
    reg xor_0_1, xor_2_3;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            xor_reg <= 4'b0;
            xor_0_1 <= 1'b0;
            xor_2_3 <= 1'b0;
        end else begin
            xor_reg <= in;
            xor_0_1 <= xor_reg[0] ^ xor_reg[1];
            xor_2_3 <= xor_reg[2] ^ xor_reg[3];
        end
    end
    assign out = xor_0_1 ^ xor_2_3;
endmodule

// Top-level module instantiating the pipelined gates
module TopModule(
    input  [3:0] in,
    input  clk,
    input  rst_n,
    output out_and,
    output out_or,
    output out_xor
);
    PipelinedAND andGate(in, clk, rst_n, out_and);
    PipelinedOR orGate(in, clk, rst_n, out_or);
    PipelinedXOR xorGate(in, clk, rst_n, out_xor);
endmodule