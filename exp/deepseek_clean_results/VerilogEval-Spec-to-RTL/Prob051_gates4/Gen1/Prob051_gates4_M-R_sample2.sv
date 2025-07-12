module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND implementation as cascaded 2-input ANDs
    wire and_temp1 = in[0] & in[1];
    wire and_temp2 = in[2] & in[3];
    assign out_and = and_temp1 & and_temp2;

    // OR implementation as cascaded 2-input ORs
    wire or_temp1 = in[0] | in[1];
    wire or_temp2 = in[2] | in[3];
    assign out_or = or_temp1 | or_temp2;

    // XOR implementation as cascaded 2-input XORs
    wire xor_temp1 = in[0] ^ in[1];
    wire xor_temp2 = in[2] ^ in[3];
    assign out_xor = xor_temp1 ^ xor_temp2;

endmodule