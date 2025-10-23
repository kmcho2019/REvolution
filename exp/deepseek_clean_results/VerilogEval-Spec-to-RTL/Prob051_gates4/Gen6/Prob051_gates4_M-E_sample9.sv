module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Stage 1: Pairwise operations
    wire and01, and23;
    wire or01, or23;
    wire xor01, xor23;
    
    assign and01 = in[0] & in[1];
    assign and23 = in[2] & in[3];
    
    assign or01 = in[0] | in[1];
    assign or23 = in[2] | in[3];
    
    assign xor01 = in[0] ^ in[1];
    assign xor23 = in[2] ^ in[3];

    // Stage 2: Final combination
    assign out_and = and01 & and23;
    assign out_or = or01 | or23;
    assign out_xor = xor01 ^ xor23;

endmodule