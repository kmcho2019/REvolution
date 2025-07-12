module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // Explicit bit-wise operations
    assign out_and = in[0] & in[1] & in[2] & in[3];  // 4-input AND
    assign out_or  = in[0] | in[1] | in[2] | in[3];  // 4-input OR
    assign out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];  // 4-input XOR

endmodule