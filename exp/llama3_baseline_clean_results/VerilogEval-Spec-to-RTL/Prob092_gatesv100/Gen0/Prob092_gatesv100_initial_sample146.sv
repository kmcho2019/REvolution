module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: Each bit indicates whether the corresponding input bit and its neighbor to the left are '1'.
    assign out_both[99] = 1'b0; // MSB has no left neighbor
    assign out_both[98:0] = in[98:0] & {in[98:1], 1'b0};

    // out_any: Each bit indicates whether any of the corresponding input bit and its neighbor to the right are '1'.
    assign out_any[0] = 1'b0; // LSB has no right neighbor
    assign out_any[99:1] = in[99:1] | {1'b0, in[99:1]};

    // out_different: Each bit indicates whether the corresponding input bit is different from its neighbor to the left.
    assign out_different[99:1] = in[99:1] ^ in[98:0];
    assign out_different[0] = in[0] ^ in[99]; // wrap-around case for LSB

endmodule