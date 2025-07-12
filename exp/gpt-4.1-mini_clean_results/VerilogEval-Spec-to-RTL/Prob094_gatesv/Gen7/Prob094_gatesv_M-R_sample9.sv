module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Neighbors for out_both (left neighbor): in shifted left by 1, MSB has no neighbor
    wire [3:0] left_neighbor_both;
    assign left_neighbor_both = {in[2:0], 1'b0}; // in[3] has no left neighbor

    // Neighbors for out_any (right neighbor): in shifted right by 1, LSB has no neighbor
    wire [3:0] right_neighbor_any;
    assign right_neighbor_any = {1'b0, in[3:1]}; // in[0] has no right neighbor

    // Neighbors for out_different: wrap-around left neighbor (in[(i+1) mod 4])
    wire [3:0] left_neighbor_diff;
    assign left_neighbor_diff = {in[0], in[3:1]}; // wrap-around shift left by 1

    // Compute out_both: bitwise AND with left neighbor; out_both[3] = 0 as no neighbor
    assign out_both[3] = 1'b0;
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];

    // Compute out_any: bitwise OR with right neighbor; out_any[0] = 0 as no neighbor
    assign out_any[0] = 1'b0;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // Compute out_different: XOR with wrap-around neighbor
    assign out_different = in ^ left_neighbor_diff;

endmodule