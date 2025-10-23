module TopModule (
    input  clk,
    input  in,
    output out
);

reg out_reg;
assign out = out_reg;

always_ff @(posedge clk) begin
    out_reg <= in ^ out;
end

endmodule