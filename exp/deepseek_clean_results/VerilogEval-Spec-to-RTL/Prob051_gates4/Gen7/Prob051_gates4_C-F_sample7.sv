module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: true only if all inputs are 1
    output out_or,        // 4-input OR: true if any input is 1
    output out_xor        // 4-input XOR: true if odd number of inputs are 1
);

    // Optimal implementation using reduction operators for AND/OR
    assign out_and = &in; // Equivalent to in[3] & in[2] & in[1] & in[0]
    assign out_or  = |in; // Equivalent to in[3] | in[2] | in[1] | in[0]

    // Balanced XOR tree for optimal timing
    wire xor_pair1, xor_pair2;
    assign xor_pair1 = in[0] ^ in[1]; // XOR of lower bits
    assign xor_pair2 = in[2] ^ in[3]; // XOR of upper bits
    assign out_xor = xor_pair1 ^ xor_pair2; // Final XOR

endmodule