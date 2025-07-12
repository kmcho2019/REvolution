module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// For out_both:
// out_both[i] = in[i] & in[i+1] for i=0 to 98
// out_both[99] = 0 (no neighbor to left)
wire [99:0] in_shifted_left = {in[98:0], 1'b0};
assign out_both = in & in_shifted_left;

// For out_any:
// out_any[i] = in[i] | in[i-1] for i=1 to 99
// out_any[0] = 0 (no neighbor to right)
wire [99:0] in_shifted_right = {1'b0, in[99:1]};
assign out_any = in | in_shifted_right;
assign out_any[0] = 1'b0; // explicitly zero out bit 0

// For out_different:
// out_different[i] = in[i] ^ in[left neighbor]
// left neighbor of in[i] is in[i+1], wrapping around with i=99 neighbor at i=0
wire [99:0] in_rotated_left = {in[98:0], in[99]};
assign out_different = in ^ in_rotated_left;

endmodule