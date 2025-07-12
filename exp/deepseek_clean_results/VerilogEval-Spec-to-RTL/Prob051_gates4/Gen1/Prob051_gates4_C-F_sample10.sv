module TopModule (
    input [3:0] in,       // 4-bit input
    output out_and,       // AND of all 4 bits (1 only if all inputs are 1)
    output out_or,        // OR of all 4 bits (1 if any input is 1)
    output out_xor        // XOR of all 4 bits (1 if odd number of inputs are 1)
);

    // Reduction operations for 4-input gates
    assign out_and = &in; // AND reduction: out_and = in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in; // OR reduction:  out_or = in[3] | in[2] | in[1] | in[0]
    assign out_xor = ^in; // XOR reduction: out_xor = in[3] ^ in[2] ^ in[1] ^ in[0]

endmodule