module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Continuous assignment for XOR
assign out_assign = a ^ b;

// Combinational always block for XOR
always_comb begin
    out_always_comb = a ^ b;
end

// Sequential logic (clocked always block) for XOR
reg out_always_ff_reg; // internal reg for out_always_ff
always_ff @(posedge clk) begin
    out_always_ff_reg = a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule