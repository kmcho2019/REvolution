module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Internal register to hold the output of the D flip-flop
assign out = out_reg; // Continuously assign the internal register to the output

always @(posedge clk) // Positive edge triggered
    out_reg <= in ^ out_reg; // XOR the input with the current output and assign to the internal register

endmodule