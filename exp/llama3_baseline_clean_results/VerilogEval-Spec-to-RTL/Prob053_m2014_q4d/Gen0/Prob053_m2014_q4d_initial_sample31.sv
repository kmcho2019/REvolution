module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // internal register to store the output of the DFF
assign out = out_reg; // assign the output of the DFF to the output port

always @(posedge clk) // positive edge triggered by clk
    out_reg <= in ^ out; // XOR the input 'in' with the output 'out' of the DFF

endmodule