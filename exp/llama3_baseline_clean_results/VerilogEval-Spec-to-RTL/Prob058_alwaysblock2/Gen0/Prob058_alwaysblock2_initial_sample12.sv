module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

// Continuous assignment XOR gate
assign out_assign = a ^ b;

// Combinational always block XOR gate
always_comb begin
    out_always_comb = a ^ b;
end

// Clocked always block XOR gate with flip-flop
logic internal_out_always_ff;
always_ff @(posedge clk) begin
    internal_out_always_ff <= a ^ b;
end
assign out_always_ff = internal_out_always_ff;

endmodule