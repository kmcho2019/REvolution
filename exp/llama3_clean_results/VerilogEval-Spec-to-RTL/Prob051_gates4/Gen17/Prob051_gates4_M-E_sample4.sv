module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Count the number of 1s in the input
    wire [1:0] count;
    assign count[0] = in[0] ^ in[1];
    assign count[1] = in[2] ^ in[3];

    // AND operation: all inputs must be 1
    assign out_and = (in[0] & in[1] & in[2] & in[3]);

    // OR operation: at least one input must be 1
    assign out_or = (in[0] | in[1] | in[2] | in[3]);

    // XOR operation: an odd number of inputs must be 1
    assign out_xor = (count[0] ^ count[1]);

    // Alternative implementation for XOR using direct comparison
    // assign out_xor = (in[0] ^ in[1] ^ in[2] ^ in[3]);

endmodule