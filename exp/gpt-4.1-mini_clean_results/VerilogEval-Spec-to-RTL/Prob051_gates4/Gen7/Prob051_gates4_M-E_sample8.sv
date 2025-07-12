module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Intermediate pairwise ANDs (overlapping)
wire and_01, and_12, and_23;
assign and_01 = in[0] & in[1];
assign and_12 = in[1] & in[2];
assign and_23 = in[2] & in[3];

// Final AND combining overlapping pairs:
assign out_and = and_01 & and_12 & and_23; 
// This equals in[0]&in[1]&in[2]&in[3], since each input appears in two pairs except ends

// Intermediate pairwise ORs (overlapping)
wire or_01, or_12, or_23;
assign or_01 = in[0] | in[1];
assign or_12 = in[1] | in[2];
assign or_23 = in[2] | in[3];

// Final OR combining overlapping pairs:
assign out_or = or_01 | or_12 | or_23;
// This equals in[0] | in[1] | in[2] | in[3]

// XOR prefix and suffix computation
wire xor_prefix_0, xor_prefix_1, xor_suffix_2, xor_suffix_3;
assign xor_prefix_0 = in[0];
assign xor_prefix_1 = xor_prefix_0 ^ in[1];
assign xor_suffix_3 = in[3];
assign xor_suffix_2 = xor_suffix_3 ^ in[2];

// Final XOR combining prefix and suffix overlapping at in[2] and in[1]
assign out_xor = xor_prefix_1 ^ xor_suffix_2;

endmodule