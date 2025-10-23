module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: true when all inputs are 1
    output out_or,        // 4-input OR: true when any input is 1
    output out_xor        // 4-input XOR: true for odd number of 1s
);

    // Optimal reduction operators for AND/OR
    assign out_and = &in; // Equivalent to in[0] & in[1] & in[2] & in[3]
    assign out_or = |in;  // Equivalent to in[0] | in[1] | in[2] | in[3]

    // Balanced XOR tree for optimal timing
    wire xor_first_pair = in[0] ^ in[1];  // XOR of bits 0 and 1
    wire xor_second_pair = in[2] ^ in[3]; // XOR of bits 2 and 3
    assign out_xor = xor_first_pair ^ xor_second_pair; // Final XOR

endmodule