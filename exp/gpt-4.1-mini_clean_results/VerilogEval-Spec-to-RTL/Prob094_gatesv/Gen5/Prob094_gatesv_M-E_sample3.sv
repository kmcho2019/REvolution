module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift in left by 1 for out_both neighbor to left (higher index)
    // Highest bit out_both[3] has no neighbor to left, so mask it off
    wire [3:0] in_left_shift = {in[2:0], 1'b0};
    assign out_both = in & in_left_shift & 4'b0111; // Mask out bit 3

    // Shift in right by 1 for out_any neighbor to right (lower index)
    // Lowest bit out_any[0] has no neighbor to right, mask it off
    wire [3:0] in_right_shift = {1'b0, in[3:1]};
    assign out_any = (in | in_right_shift) & 4'b1110; // Mask out bit 0

    // Rotate left by 1 to get neighbor to left with wrap-around for out_different
    wire [3:0] in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule