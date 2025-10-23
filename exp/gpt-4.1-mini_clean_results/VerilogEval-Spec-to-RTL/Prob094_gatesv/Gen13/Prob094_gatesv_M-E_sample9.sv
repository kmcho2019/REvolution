module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Left neighbor vector: shift 'in' left by 1, fill LSB with 0 (no neighbor for MSB)
    wire [3:0] left_neighbor = {in[2:0], 1'b0};

    // Right neighbor vector: shift 'in' right by 1, fill MSB with 0 (no neighbor for LSB)
    wire [3:0] right_neighbor = {1'b0, in[3:1]};

    // For out_both, each bit AND with left neighbor, set MSB (bit 3) to 0 since no left neighbor
    assign out_both = (in & left_neighbor) & 4'b0111;

    // For out_any, each bit OR with right neighbor, set LSB (bit 0) to 0 since no right neighbor
    assign out_any = (in | right_neighbor) & 4'b1110;

    // For out_different, treat vector as circular: rotate left by 1 to get left neighbors with wrap-around
    wire [3:0] circular_left = {in[2:0], in[3]};
    assign out_different = in ^ circular_left;

endmodule