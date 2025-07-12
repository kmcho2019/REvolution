module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output of the D flip-flop
assign out = out_reg; // Continuous assignment to drive the output

always @(posedge clk) // Positive edge triggered
    out_reg <= in ^ out_reg; // XOR the input with the current output and update the register

endmodule