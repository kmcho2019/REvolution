module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Using a continuous assignment statement
assign out_assign = a ^ b;

// Using a combinational always block
always_comb begin
    out_always_comb = a ^ b;
end

// Using a clocked always block (sequential logic)
reg out_always_ff_reg;
always_ff @(posedge clk) begin
    out_always_ff_reg <= a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule