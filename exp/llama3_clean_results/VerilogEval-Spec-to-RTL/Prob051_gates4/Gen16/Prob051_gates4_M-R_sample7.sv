module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly implement the 4-input AND gate
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // Directly implement the 4-input OR gate
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // Directly implement the 4-input XOR gate
    // Since XOR is associative, we can chain the operations
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule