module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Left neighbor vector for out_both and out_different
    // For out_both: left neighbor is in shifted left by 1; MSB neighbor undefined, set to 0
    // For out_different: left neighbor with wrap-around (circular shift left by 1)
    wire [99:0] left_neighbor_both = {in[98:0], 1'b0};
    wire [99:0] left_neighbor_diff = {in[98:0], in[99]}; // wrap around: in[99] moves to in[0]'s neighbor

    // Right neighbor vector for out_any
    // Right neighbor is in shifted right by 1; LSB neighbor undefined, set to 0
    wire [99:0] right_neighbor_any = {1'b0, in[99:1]};

    // out_both: bitwise AND of in and left neighbor, except out_both[99] = 0
    assign out_both = in & left_neighbor_both;

    // out_any: bitwise OR of in and right neighbor, except out_any[0] = 0
    assign out_any = in | right_neighbor_any;
    assign out_any[0] = 1'b0;

    // out_different: bitwise XOR of in and left neighbor with wrap-around
    assign out_different = in ^ left_neighbor_diff;

endmodule