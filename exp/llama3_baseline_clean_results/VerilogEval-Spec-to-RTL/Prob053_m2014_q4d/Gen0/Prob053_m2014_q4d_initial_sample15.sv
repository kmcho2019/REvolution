module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // internal register to hold the flip-flop's output
assign out = out_reg; // assign the internal register to the output

always @(posedge clk) // positive edge triggered
    out_reg <= in ^ out; // XOR 'in' with the current output 'out'

endmodule