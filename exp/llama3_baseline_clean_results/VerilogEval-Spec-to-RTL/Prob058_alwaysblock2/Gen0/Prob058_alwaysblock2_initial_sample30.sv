module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Continuous assignment for out_assign
assign out_assign = a ^ b;

// Combinational always block for out_always_comb
always_comb begin
    out_always_comb = a ^ b;
end

// Clocked always block for out_always_ff
logic out_always_ff_reg; // Internal register to hold the value
always_ff @(posedge clk) begin
    out_always_ff_reg = a ^ b; // Update the internal register on positive edge of clk
end
assign out_always_ff = out_always_ff_reg; // Drive the output from the internal register

endmodule