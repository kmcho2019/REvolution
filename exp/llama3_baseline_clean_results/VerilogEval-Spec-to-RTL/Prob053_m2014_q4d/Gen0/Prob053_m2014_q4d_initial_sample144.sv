module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // register to store the output of the flip-flop
assign out = out_reg; // continuous assignment to output

always @ (posedge clk) // positive edge triggered
    out_reg <= in ^ out_reg; // XOR 'in' with the current output and assign to the register

endmodule