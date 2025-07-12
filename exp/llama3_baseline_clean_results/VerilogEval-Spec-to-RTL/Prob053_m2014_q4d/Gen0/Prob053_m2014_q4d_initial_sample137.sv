module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg;

always @(posedge clk) begin
    out_reg <= in ^ out_reg;
end

assign out = out_reg;

endmodule