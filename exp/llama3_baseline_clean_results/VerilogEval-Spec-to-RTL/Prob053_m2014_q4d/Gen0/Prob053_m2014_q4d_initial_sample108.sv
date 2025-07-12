module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // Internal register to hold the output value
assign out = out_reg; // Continuous assignment to drive the output

always @(posedge clk) // Positive edge triggered D flip-flop
    out_reg <= in ^ out; // The input to the flip-flop is the XOR of 'in' and 'out'

endmodule