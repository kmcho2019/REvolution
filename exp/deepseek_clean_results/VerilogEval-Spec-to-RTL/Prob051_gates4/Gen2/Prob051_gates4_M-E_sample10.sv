module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate computations for AND
    wire and_01 = in[0] & in[1];
    wire and_23 = in[2] & in[3];
    assign out_and = and_01 & and_23;

    // Intermediate computations for OR
    wire or_01 = in[0] | in[1];
    wire or_23 = in[2] | in[3];
    assign out_or = or_01 | or_23;

    // Intermediate computations for XOR
    wire xor_01 = in[0] ^ in[1];
    wire xor_23 = in[2] ^ in[3];
    assign out_xor = xor_01 ^ xor_23;

endmodule