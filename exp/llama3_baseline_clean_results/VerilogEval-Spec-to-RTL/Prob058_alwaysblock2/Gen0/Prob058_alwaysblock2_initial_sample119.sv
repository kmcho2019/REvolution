module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

assign out_assign = a ^ b;

always_comb begin
    out_always_comb = a ^ b;
end

reg out_always_ff_reg;
always_ff @(posedge clk) begin
    out_always_ff_reg <= a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule