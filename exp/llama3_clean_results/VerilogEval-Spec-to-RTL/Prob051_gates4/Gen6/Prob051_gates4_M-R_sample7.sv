module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Implement the AND gate using assign statement
    assign out_and = in[0] & in[1] & in[2] & in[3];

    // Implement the OR gate using assign statement
    assign out_or = in[0] | in[1] | in[2] | in[3];

    // Implement the XOR gate using a tree-like structure
    wire xor_0_1;
    wire xor_2_3;
    assign xor_0_1 = in[0] ^ in[1];
    assign xor_2_3 = in[2] ^ in[3];
    assign out_xor = xor_0_1 ^ xor_2_3;
endmodule