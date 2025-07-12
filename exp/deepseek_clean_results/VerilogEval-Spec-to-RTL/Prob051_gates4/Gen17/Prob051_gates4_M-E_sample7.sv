module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level pairwise operations
    wire and_01 = in[0] & in[1];
    wire and_23 = in[2] & in[3];
    wire or_01  = in[0] | in[1];
    wire or_23  = in[2] | in[3];
    wire xor_01 = in[0] ^ in[1];
    wire xor_23 = in[2] ^ in[3];

    // Second level combinations
    assign out_and = and_01 & and_23;
    assign out_or  = or_01 | or_23;
    assign out_xor = xor_01 ^ xor_23;

endmodule