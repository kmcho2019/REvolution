module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // AND gate implementation using 2-input ANDs
    wire and_intermediate1;
    wire and_intermediate2;
    assign and_intermediate1 = in[0] & in[1];
    assign and_intermediate2 = in[2] & in[3];
    assign out_and = and_intermediate1 & and_intermediate2;

    // OR gate implementation using 2-input ORs
    wire or_intermediate1;
    wire or_intermediate2;
    assign or_intermediate1 = in[0] | in[1];
    assign or_intermediate2 = in[2] | in[3];
    assign out_or = or_intermediate1 | or_intermediate2;

    // XOR gate implementation using 2-input XORs
    wire xor_intermediate1;
    wire xor_intermediate2;
    assign xor_intermediate1 = in[0] ^ in[1];
    assign xor_intermediate2 = in[2] ^ in[3];
    assign out_xor = xor_intermediate1 ^ xor_intermediate2;

endmodule