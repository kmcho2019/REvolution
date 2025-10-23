module DFF(
    input clk,
    input d,
    output reg q = 1'b0
);

always @(posedge clk) begin
    q <= d;
end

endmodule

module XOR_Gate(
    input a,
    input b,
    output y
);

assign y = a ^ b;

endmodule

module AND_Gate(
    input a,
    input b,
    output y
);

assign y = a & b;

endmodule

module OR_Gate(
    input a,
    input b,
    output y
);

assign y = a | b;

endmodule

module NOR_Gate(
    input a,
    input b,
    input c,
    output y
);

assign y = ~(a | b | c);

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

wire xor_d, and_d, or_d;
wire xor_q, and_q, or_q;

DFF xor_ff(clk, xor_d, xor_q);
DFF and_ff(clk, and_d, and_q);
DFF or_ff(clk, or_d, or_q);

XOR_Gate xor_gate(x, xor_q, xor_d);
AND_Gate and_gate(x, ~and_q, and_d);
OR_Gate or_gate(x, ~or_q, or_d);

NOR_Gate nor_gate(xor_q, and_q, or_q, z);

endmodule