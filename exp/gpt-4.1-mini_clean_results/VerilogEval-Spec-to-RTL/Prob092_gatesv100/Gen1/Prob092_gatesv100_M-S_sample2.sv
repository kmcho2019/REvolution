module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// Neighbor to the left is in shifted left by 1 (MSB has no left neighbor)
wire [99:0] left_neighbor = {in[98:0], 1'b0};
// Neighbor to the right is in shifted right by 1 (LSB has no right neighbor)
wire [99:0] right_neighbor = {1'b0, in[99:1]};
// For wrap-around left neighbor (for out_different), rotate right by 1
wire [99:0] wrapped_left = {in[0], in[99:1]};

assign out_both      = in & left_neighbor;         // out_both[99]=0 automatically due to left_neighbor MSB=0
assign out_any       = in | right_neighbor;        // out_any[0]=0 automatically due to right_neighbor LSB=0
assign out_different = in ^ wrapped_left;          // wrapping neighbor comparison

endmodule