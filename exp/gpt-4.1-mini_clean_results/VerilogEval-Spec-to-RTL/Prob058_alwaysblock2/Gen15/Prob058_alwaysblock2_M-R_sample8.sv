module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Intermediate wire computing XOR
wire xor_ab;
assign xor_ab = a ^ b;

// Continuous assignment output
assign out_assign = xor_ab;

// Combinational always block output
always @(*) begin
    out_always_comb = xor_ab;
end

// Sequential always block output with flip-flop
always @(posedge clk) begin
    out_always_ff <= xor_ab;
end

endmodule