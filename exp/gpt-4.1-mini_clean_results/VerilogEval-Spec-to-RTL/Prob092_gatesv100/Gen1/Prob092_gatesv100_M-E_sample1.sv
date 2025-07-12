module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Rotate input left by 1 bit, but for out_both, no wrap-around since out_both[99]=0
    wire [99:0] in_left_neighbor = {in[98:0], 1'b0};

    // out_both: bit i = in[i] & in_left_neighbor[i], and out_both[99] = 0 by construction
    assign out_both = in & in_left_neighbor;

    // Rotate input right by 1 bit with zero padding for out_any (out_any[0]=0)
    wire [99:0] in_right_neighbor = {1'b0, in[99:1]};

    // out_any: bit i = in[i] | in_right_neighbor[i]
    assign out_any = in | in_right_neighbor;

    // Rotate input left by 1 bit with wrap-around for out_different
    wire [99:0] in_left_neighbor_wrap = {in[98:0], in[99]};

    // out_different: bit i = in[i] ^ in_left_neighbor_wrap[i]
    assign out_different = in ^ in_left_neighbor_wrap;

endmodule