module TopModule (
    input clk,
    input in,
    output out
);

wire d_input;

// Structural XOR implementation
xor x1(d_input, in, out);

// Structural D flip-flop implementation
dff dff1(
    .d(d_input),
    .clk(clk),
    .q(out)
);

endmodule