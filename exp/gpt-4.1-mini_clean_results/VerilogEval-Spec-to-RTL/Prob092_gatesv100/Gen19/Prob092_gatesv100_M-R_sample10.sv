module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Neighbor to the left for bits 0 to 98 is in[i+1], for bit 99 no neighbor (0)
    wire [99:0] left_neighbor;
    assign left_neighbor[98:0] = in[99:1];
    assign left_neighbor[99] = 1'b0;

    // Neighbor to the right for bits 1 to 99 is in[i-1], for bit 0 no neighbor (0)
    wire [99:0] right_neighbor;
    assign right_neighbor[99:1] = in[98:0];
    assign right_neighbor[0] = 1'b0;

    // For out_both: current bit AND left neighbor, out_both[99] = 0
    assign out_both = in & left_neighbor;

    // For out_any: current bit OR right neighbor, out_any[0] = 0
    assign out_any = in | right_neighbor;

    // For out_different: XOR with left neighbor, with wrap-around for bit 99 (neighbor is in[0])
    assign out_different[98:0] = in[98:0] ^ in[99:1];
    assign out_different[99] = in[99] ^ in[0];

endmodule