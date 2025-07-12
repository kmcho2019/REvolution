module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Compute AND output by checking if all input bits are set
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // Compute OR output by checking if at least one input bit is set
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // Compute XOR output by using bitwise XOR operation
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule