module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Hierarchical AND: (in[3] & in[2]) & (in[1] & in[0])
wire and_upper = in[3] & in[2];
wire and_lower = in[1] & in[0];
assign out_and = and_upper & and_lower;

// Hierarchical OR: (in[3] | in[2]) | (in[1] | in[0])
wire or_upper = in[3] | in[2];
wire or_lower = in[1] | in[0];
assign out_or = or_upper | or_lower;

// XOR using reduction operator is already optimal
assign out_xor = ^in;

endmodule