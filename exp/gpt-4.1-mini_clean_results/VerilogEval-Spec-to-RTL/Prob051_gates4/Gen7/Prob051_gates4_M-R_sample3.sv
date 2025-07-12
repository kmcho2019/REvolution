module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Intermediate signals for AND gate stages
wire and_stage0, and_stage1;
assign and_stage0 = in[0] & in[1];
assign and_stage1 = in[2] & in[3];
assign out_and = and_stage0 & and_stage1;

// Intermediate signals for OR gate stages
wire or_stage0, or_stage1;
assign or_stage0 = in[0] | in[1];
assign or_stage1 = in[2] | in[3];
assign out_or = or_stage0 | or_stage1;

// Intermediate signals for XOR gate stages
wire xor_stage0, xor_stage1;
assign xor_stage0 = in[0] ^ in[1];
assign xor_stage1 = in[2] ^ in[3];
assign out_xor = xor_stage0 ^ xor_stage1;

endmodule