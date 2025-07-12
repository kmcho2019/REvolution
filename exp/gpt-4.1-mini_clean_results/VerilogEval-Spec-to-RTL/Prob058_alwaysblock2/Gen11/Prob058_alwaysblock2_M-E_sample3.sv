module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

reg seq_stage1;

// Continuous assignment: direct XOR of inputs
assign out_assign = a ^ b;

// Combinational always block: independently compute XOR
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block: two-stage pipeline for XOR
always @(*) begin
    seq_stage1 = a ^ b;
end

always @(posedge clk) begin
    out_always_ff <= seq_stage1;
end

endmodule