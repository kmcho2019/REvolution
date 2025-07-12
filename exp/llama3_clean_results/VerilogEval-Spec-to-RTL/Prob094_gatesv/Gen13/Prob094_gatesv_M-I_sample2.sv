module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: Both the corresponding input bit and its neighbour to the left are '1'
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;  // No neighbour to the left for in[3]

    // out_any: Any of the corresponding input bit and its neighbour to the right are '1'
    assign out_any[0] = in[0];  // No neighbour to the right for in[0]
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different: The corresponding input bit is different from its neighbour to the left (wrapping around)
    assign out_different[0] = in[0] ^ in[3];  // in[0]'s neighbour to the left is in[3] (wrapping around)
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule