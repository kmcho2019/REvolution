module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

wire and_level1_0, and_level1_1;
wire or_level1_0, or_level1_1;
wire xor_level1_0, xor_level1_1;

// 2-input AND tree
assign and_level1_0 = in[0] & in[1];
assign and_level1_1 = in[2] & in[3];
assign out_and      = and_level1_0 & and_level1_1;

// 2-input OR tree
assign or_level1_0 = in[0] | in[1];
assign or_level1_1 = in[2] | in[3];
assign out_or      = or_level1_0 | or_level1_1;

// 2-input XOR tree
assign xor_level1_0 = in[0] ^ in[1];
assign xor_level1_1 = in[2] ^ in[3];
assign out_xor      = xor_level1_0 ^ xor_level1_1;

endmodule