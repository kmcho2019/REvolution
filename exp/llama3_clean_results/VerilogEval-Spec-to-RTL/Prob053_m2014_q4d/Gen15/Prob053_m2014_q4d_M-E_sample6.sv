module DFlipFlop(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

module XORGate(
    input a,
    input b,
    output out
);

assign out = a ^ b;

endmodule

module TopModule(
    input clk,
    input in,
    output out
);

wire d;

// Instantiate the XOR gate
XORGate xor_gate(
    .a(in),
    .b(out),
    .out(d)
);

// Instantiate the D flip-flop
DFlipFlop d_flip_flop(
    .clk(clk),
    .d(d),
    .q(out)
);

endmodule