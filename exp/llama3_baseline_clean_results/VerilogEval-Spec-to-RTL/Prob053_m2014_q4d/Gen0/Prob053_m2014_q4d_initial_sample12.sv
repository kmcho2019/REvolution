module TopModule (
    input  clk,
    input  in,
    output out
);

reg out_reg;

assign out = out_reg;

always @ (posedge clk)
    out_reg <= in ^ out;

endmodule