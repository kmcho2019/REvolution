module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Define left neighbors, wrapping for in[3]
    wire [3:0] left_neighbor;
    assign left_neighbor[0] = in[1];
    assign left_neighbor[1] = in[2];
    assign left_neighbor[2] = in[3];
    // For in[3], wrapping around: left neighbor is in[0]
    assign left_neighbor[3] = in[0];

    // Define right neighbors, no wrapping, so in[0] has no right neighbor
    wire [3:0] right_neighbor;
    assign right_neighbor[3] = in[2];
    assign right_neighbor[2] = in[1];
    assign right_neighbor[1] = in[0];
    assign right_neighbor[0] = 1'b0; // no right neighbor for in[0]

    // Compute out_both: in[i] & left_neighbor[i], but out_both[3]=0 since no left neighbor for in[3] in this context
    assign out_both = {1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // Compute out_any: in[i] | right_neighbor[i]
    assign out_any = {in[3] | right_neighbor[3], in[2] | right_neighbor[2], in[1] | right_neighbor[1], 1'b0};

    // Compute out_different: in[i] ^ left_neighbor[i], wrapping around for in[3]
    assign out_different = in ^ left_neighbor;

endmodule