module TopModule (
    input  clk,
    input  a,
    input  b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Continuous assignment for out_assign - direct XOR
assign out_assign = a ^ b;

// Combinational always block with blocking assignment
always @(a, b) begin
    out_always_comb = a ^ b;
end

// Sequential always block with intermediate register storing XOR
reg xor_reg;

always @(posedge clk) begin
    xor_reg <= a ^ b;
    out_always_ff <= xor_reg;
end

endmodule