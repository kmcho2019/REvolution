module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock,
    output out_delayed
);

reg out_alwaysblock_reg;
reg out_delayed_reg;

assign out_assign = a & b;

always @(posedge clk) begin
    out_alwaysblock_reg <= a & b;
    out_delayed_reg <= out_alwaysblock_reg;
end

assign out_alwaysblock = out_alwaysblock_reg;
assign out_delayed = out_delayed_reg;

endmodule