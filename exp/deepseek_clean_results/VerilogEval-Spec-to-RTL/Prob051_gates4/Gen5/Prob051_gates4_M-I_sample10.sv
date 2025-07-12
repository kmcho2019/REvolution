module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Reduction operators for AND and OR (optimal implementation)
    assign out_and = &in;
    assign out_or  = |in;

    // Balanced XOR tree implemented more concisely
    assign out_xor = (in[0] ^ in[1]) ^ (in[2] ^ in[3]);

endmodule