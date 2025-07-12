module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

wire and_stage1_0, and_stage1_1;
wire or_stage1_0, or_stage1_1;
wire xor_stage1_0, xor_stage1_1;

// Stage 1: pairwise operations
assign and_stage1_0 = in[0] & in[1];
assign and_stage1_1 = in[2] & in[3];

assign or_stage1_0 = in[0] | in[1];
assign or_stage1_1 = in[2] | in[3];

assign xor_stage1_0 = in[0] ^ in[1];
assign xor_stage1_1 = in[2] ^ in[3];

// Stage 2: combine pairwise results
assign out_and = and_stage1_0 & and_stage1_1;
assign out_or  = or_stage1_0 | or_stage1_1;
assign out_xor = xor_stage1_0 ^ xor_stage1_1;

endmodule