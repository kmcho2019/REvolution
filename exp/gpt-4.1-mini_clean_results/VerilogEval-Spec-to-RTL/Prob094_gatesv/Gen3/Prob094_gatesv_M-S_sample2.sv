module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Wrap neighbor to the left (index+1 modulo 4)
    wire [3:0] neighbor_left = {in[0], in[3:1]};
    // Wrap neighbor to the right (index-1 modulo 4)
    wire [3:0] neighbor_right = {in[2:0], in[3]};

    assign out_both      = in & neighbor_left;   // AND with left neighbor (wrap-around)
    assign out_any       = in | neighbor_right;  // OR with right neighbor (wrap-around)
    assign out_different = in ^ neighbor_left;   // XOR with left neighbor (wrap-around)

endmodule