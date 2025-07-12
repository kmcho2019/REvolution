module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the state of the D flip-flop
assign out = out_reg; // Continuous assignment to output the current state

always @(posedge clk) // Positive edge triggered
    out_reg <= in ^ out_reg; // Update the state with the XOR of 'in' and current 'out'

endmodule