module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: true only if all inputs are 1
    output out_or,        // 4-input OR: true if any input is 1
    output out_xor       // 4-input XOR: true if odd number of inputs are 1
);

    // All operations use reduction operators for optimal implementation
    assign out_and = &in; // 4-input AND (in[3] & in[2] & in[1] & in[0])
    assign out_or  = |in; // 4-input OR  (in[3] | in[2] | in[1] | in[0])
    assign out_xor = ^in; // 4-input XOR (in[3] ^ in[2] ^ in[1] ^ in[0])

endmodule