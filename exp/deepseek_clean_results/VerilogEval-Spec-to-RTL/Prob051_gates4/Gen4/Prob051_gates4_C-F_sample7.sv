module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Use reduction operators for AND and OR - most concise and efficient
    assign out_and = &in;
    assign out_or  = |in;

    // Use balanced tree structure for XOR - better timing characteristics
    wire xor_low = in[0] ^ in[1];
    wire xor_high = in[2] ^ in[3];
    assign out_xor = xor_low ^ xor_high;

endmodule