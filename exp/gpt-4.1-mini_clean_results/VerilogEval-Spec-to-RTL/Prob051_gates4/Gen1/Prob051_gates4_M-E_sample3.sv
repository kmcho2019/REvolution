module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// AND: ((in[0] & in[1]) & (in[2] & in[3]))
wire and_lower, and_upper;
assign and_lower = in[0] & in[1];
assign and_upper = in[2] & in[3];
assign out_and = and_lower & and_upper;

// OR: ((in[0] | in[1]) | (in[2] | in[3]))
wire or_lower, or_upper;
assign or_lower = in[0] | in[1];
assign or_upper = in[2] | in[3];
assign out_or = or_lower | or_upper;

// XOR: (((in[0] ^ in[1]) ^ in[2]) ^ in[3])
wire xor_01, xor_012;
assign xor_01 = in[0] ^ in[1];
assign xor_012 = xor_01 ^ in[2];
assign out_xor = xor_012 ^ in[3];

endmodule