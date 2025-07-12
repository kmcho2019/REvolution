module TopModule(
    input  clk,
    input  in,
    output reg out
);

reg out_reg;

always @(posedge clk) begin
    out_reg <= in ^ out;
end

assign out = out_reg;

endmodule