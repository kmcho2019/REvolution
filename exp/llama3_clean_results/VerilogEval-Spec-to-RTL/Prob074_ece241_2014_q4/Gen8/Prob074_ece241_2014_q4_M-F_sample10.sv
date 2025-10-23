// D flip-flop module
module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// XOR gate module
module XORGate(
    input a,
    input b,
    output reg out
);

assign out = a ^ b;

endmodule

// AND gate module
module ANDGate(
    input a,
    input b,
    output reg out
);

assign out = a & b;

endmodule

// OR gate module
module ORGate(
    input a,
    input b,
    output reg out
);

assign out = a | b;

endmodule

// NOR gate module
module NORGate(
    input a,
    input b,
    input c,
    output reg out
);

assign out = ~(a | b | c);

endmodule

// Top-level module
module TopModule(
    input clk,
    input x,
    output reg z
);

wire xor_out, and_out, or_out;
reg xor_q, and_q, or_q;
wire xor_input, and_input, or_input;

DFF xor_dff(clk, xor_input, xor_q);
DFF and_dff(clk, and_input, and_q);
DFF or_dff(clk, or_input, or_q);

assign xor_input = x ^ xor_q;
assign and_input = x & ~and_q;
assign or_input = x | ~or_q;

assign xor_out = xor_input;
assign and_out = and_input;
assign or_out = or_input;

NORGate nor_gate(xor_out, and_out, or_out, z);

initial begin
    xor_q = 0;
    and_q = 0;
    or_q = 0;
end

endmodule