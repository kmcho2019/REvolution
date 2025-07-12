module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Compute the bitwise AND of all inputs
    assign out_and = in[0] & in[1] & in[2] & in[3];

    // Compute the bitwise OR of all inputs
    assign out_or = in[0] | in[1] | in[2] | in[3];

    // Compute the bitwise XOR of all inputs
    // This is done by using the property: a ^ b ^ c ^ d = ((a ^ b) ^ (c ^ d))
    assign out_xor = (in[0] ^ in[1] ^ in[2] ^ in[3]);

    // Alternatively, we can use a single expression to compute the XOR
    // assign out_xor = (in[0] ^ in[1]) ^ (in[2] ^ in[3]);
endmodule