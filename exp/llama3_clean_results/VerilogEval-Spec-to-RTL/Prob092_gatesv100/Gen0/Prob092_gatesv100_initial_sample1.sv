module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize the out_both vector
    assign out_both[99] = 1'b0; // out_both[99] is always 0
    assign out_both[98:0] = in[98:0] & in[99:1];

    // Initialize the out_any vector
    assign out_any[0] = 1'b0; // out_any[0] is always 0
    assign out_any[99:1] = in[99:1] | in[98:0];

    // Initialize the out_different vector
    assign out_different[99] = in[99] ^ in[0];
    assign out_different[98:0] = in[98:0] ^ in[99:1];

endmodule