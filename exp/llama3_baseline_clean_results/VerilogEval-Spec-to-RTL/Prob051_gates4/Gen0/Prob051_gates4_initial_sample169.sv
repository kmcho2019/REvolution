module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Using built-in logical operators to implement AND, OR, and XOR operations
    assign out_and = in[3] & in[2] & in[1] & in[0];
    assign out_or  = in[3] | in[2] | in[1] | in[0];
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule