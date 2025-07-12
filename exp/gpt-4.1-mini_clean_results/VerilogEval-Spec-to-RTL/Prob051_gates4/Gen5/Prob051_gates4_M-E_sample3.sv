module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Hierarchical two-level AND: (in0 & in1) & (in2 & in3)
wire and_pair0, and_pair1;
assign and_pair0 = in[0] & in[1];
assign and_pair1 = in[2] & in[3];
assign out_and = and_pair0 & and_pair1;

// Hierarchical two-level OR: (in0 | in1) | (in2 | in3)
wire or_pair0, or_pair1;
assign or_pair0 = in[0] | in[1];
assign or_pair1 = in[2] | in[3];
assign out_or = or_pair0 | or_pair1;

// XOR chain: ((in0 ^ in1) ^ in2) ^ in3
wire xor0, xor1, xor2;
assign xor0 = in[0] ^ in[1];
assign xor1 = xor0 ^ in[2];
assign xor2 = xor1 ^ in[3];
assign out_xor = xor2;

endmodule