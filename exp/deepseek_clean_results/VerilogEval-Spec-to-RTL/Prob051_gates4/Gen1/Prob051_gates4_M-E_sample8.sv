module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Intermediate wires for AND
    wire and_01, and_23;
    assign and_01 = in[0] & in[1];
    assign and_23 = in[2] & in[3];
    assign out_and = and_01 & and_23;

    // Intermediate wires for OR
    wire or_01, or_23;
    assign or_01 = in[0] | in[1];
    assign or_23 = in[2] | in[3];
    assign out_or = or_01 | or_23;

    // Intermediate wires for XOR
    wire xor_01, xor_23;
    assign xor_01 = in[0] ^ in[1];
    assign xor_23 = in[2] ^ in[3];
    assign out_xor = xor_01 ^ xor_23;

endmodule