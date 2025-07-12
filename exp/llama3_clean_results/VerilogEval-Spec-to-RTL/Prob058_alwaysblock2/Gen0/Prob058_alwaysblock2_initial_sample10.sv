module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Using assign statement for continuous assignment
assign out_assign = a ^ b;

// Using always @* for combinational logic
always @(*) begin
    out_always_comb = a ^ b;
end

// Using always @(posedge clk) for clocked logic, introducing a flip-flop
reg out_always_ff_reg; // Internal reg to hold the flip-flop value
always @(posedge clk) begin
    out_always_ff_reg = a ^ b;
end
assign out_always_ff = out_always_ff_reg;

endmodule