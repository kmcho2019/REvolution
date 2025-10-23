module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Neighbor to the left (wrap-around)
    wire [3:0] left = {in[2:0], in[3]};
    // Neighbor to the right (wrap-around)
    wire [3:0] right = {in[0], in[3:1]};

    // For out_both, bit 3 has no left neighbor, mask it out
    assign out_both = (in & left) & 4'b0111;
    // For out_any, bit 0 has no right neighbor, mask it out
    assign out_any  = (in | right) & 4'b1110;
    // out_different uses wrap-around left neighbor (as left)
    assign out_different = in ^ left;

endmodule