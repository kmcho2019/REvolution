module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create shifted vectors representing neighbors
    wire [3:0] left_neighbor  = {in[2:0], 1'b0};   // Left neighbor for bits [0..2], in[3] has no left neighbor
    wire [3:0] right_neighbor = {1'b0, in[3:1]};   // Right neighbor for bits [1..3], in[0] has no right neighbor

    // For out_both: current bit AND its left neighbor; out_both[3] = 0 (no left neighbor)
    assign out_both = in & left_neighbor;

    // For out_any: current bit OR its right neighbor; out_any[0] = 0 (no right neighbor)
    assign out_any = in | right_neighbor;

    // For out_different: rotate input left by 1 to get left neighbors (wrap-around)
    wire [3:0] rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ rotated_left;

endmodule