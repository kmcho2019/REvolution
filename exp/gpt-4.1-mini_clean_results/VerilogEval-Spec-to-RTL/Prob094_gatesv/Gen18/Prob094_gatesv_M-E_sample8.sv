module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // For out_both: Check if bit and neighbor to the left (higher index) are both 1
    // Create left shifted input with zero LSB for no neighbor at highest bit
    wire [3:0] in_left_shifted = {in[2:0], 1'b0};
    // AND original input with left shifted
    wire [3:0] both_temp = in & in_left_shifted;
    // Mask off the highest bit (no left neighbor)
    assign out_both = {both_temp[3:1], 1'b0};

    // For out_any: Check if bit or neighbor to the right (lower index) are 1
    // Create right shifted input with zero MSB for no neighbor at lowest bit
    wire [3:0] in_right_shifted = {1'b0, in[3:1]};
    // OR original input with right shifted
    wire [3:0] any_temp = in | in_right_shifted;
    // Mask off the lowest bit (no right neighbor)
    assign out_any = {1'b0, any_temp[3:1]};

    // For out_different: bitwise XOR with left neighbor (wrapping around)
    // Rotate input left by 1 to get left neighbors with wrap-around
    wire [3:0] in_rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rotated_left;

endmodule