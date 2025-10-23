module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Using assign statement
assign out_assign = a ^ b;

// Using combinational always block
always @(*) begin
    out_always_comb = a ^ b;
end

// Using clocked always block
reg out_always_ff_reg;
always @(posedge clk) begin
    out_always_ff_reg <= a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule