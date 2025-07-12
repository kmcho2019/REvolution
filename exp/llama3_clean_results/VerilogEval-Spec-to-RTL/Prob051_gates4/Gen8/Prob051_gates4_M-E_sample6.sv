module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly implement 4-input AND gate using bitwise AND
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // Directly implement 4-input OR gate using bitwise OR
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // Directly implement 4-input XOR gate using bitwise XOR
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule