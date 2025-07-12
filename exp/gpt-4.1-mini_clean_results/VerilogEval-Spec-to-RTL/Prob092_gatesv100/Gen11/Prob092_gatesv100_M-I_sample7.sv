module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// For out_both, neighbor to left: in[i] & in[i+1]
// We align neighbors by concatenating zero at LSB: {in[98:0], 1'b0}
wire [99:0] left_neighbor_for_both = {in[98:0], 1'b0};
assign out_both = in & left_neighbor_for_both;   // out_both[99] = 0 since left_neighbor_for_both[99] = 0

// For out_any, neighbor to right: in[i] | in[i-1]
// We align neighbors by concatenating zero at MSB: {1'b0, in[99:1]}
wire [99:0] right_neighbor_for_any = {1'b0, in[99:1]};
assign out_any = in | right_neighbor_for_any;    // out_any[0] = 0 since right_neighbor_for_any[0] = 0

// For out_different, neighbor to left with wrap-around: XOR in[i] with in[(i+1)%100]
// Rotate left by 1: {in[0], in[99:1]}
assign out_different = in ^ {in[0], in[99:1]};

endmodule