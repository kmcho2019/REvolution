module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Continuous assignment
assign out_assign = a ^ b;

// Combinational logic block
always_comb begin
    out_always_comb = a ^ b;
end

// Clocked always block with flip-flop
logic internal_ff;
always_ff @(posedge clk) begin
    internal_ff <= a ^ b;
end
assign out_always_ff = internal_ff;

endmodule