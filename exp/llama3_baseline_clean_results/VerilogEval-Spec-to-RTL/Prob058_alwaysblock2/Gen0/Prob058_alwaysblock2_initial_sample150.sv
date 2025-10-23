module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Continuous assignment for XOR
assign out_assign = a ^ b;

// Combinational logic for XOR
always_comb begin
    out_always_comb = a ^ b;
end

// Sequential logic for XOR with flip-flop
always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule