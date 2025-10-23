module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // register to hold the output
assign out = out_reg; // continuous assignment to output

always @ (posedge clk) // positive edge triggered
    out_reg <= in ^ out; // XOR operation and assign to out_reg

endmodule