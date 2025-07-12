module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Intermediate wires for hierarchical implementation
    wire and01, and23;
    wire or01, or23;
    wire xor01, xor23;

    // First level: Combine bits 0-1 and 2-3 separately
    assign and01 = in[0] & in[1];
    assign and23 = in[2] & in[3];
    assign or01  = in[0] | in[1];
    assign or23  = in[2] | in[3];
    assign xor01 = in[0] ^ in[1];
    assign xor23 = in[2] ^ in[3];

    // Second level: Combine intermediate results
    assign out_and = and01 & and23;
    assign out_or  = or01  | or23;
    assign out_xor = xor01 ^ xor23;

endmodule