module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Wrap-around left neighbor for all bits: {in[0], in[3:1]}
    wire [3:0] left_neighbor = {in[0], in[3:1]};
    // Wrap-around right neighbor for all bits: {in[2:0], in[3]}
    wire [3:0] right_neighbor = {in[2:0], in[3]};

    // Both neighbors are 1
    assign out_both = in & left_neighbor;

    // Either the bit or its right neighbor is 1
    assign out_any = in | right_neighbor;

    // Bit different from left neighbor (wrap-around)
    assign out_different = in ^ left_neighbor;

endmodule