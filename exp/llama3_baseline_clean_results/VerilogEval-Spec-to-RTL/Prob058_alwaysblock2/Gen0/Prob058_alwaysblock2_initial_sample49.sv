module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Implementation using assign statement
assign out_assign = a ^ b;

// Implementation using always_comb block
always_comb begin
    out_always_comb = a ^ b;
end

// Implementation using always_ff block (clocked)
reg out_always_ff_reg;
always_ff @(posedge clk) begin
    out_always_ff_reg <= a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule