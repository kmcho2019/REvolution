module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift left by 1 for left neighbors (bit 3 has no neighbor)
    wire [3:0] in_shift_left = {in[2:0], 1'b0};

    // Shift right by 1 for right neighbors (bit 0 has no neighbor)
    wire [3:0] in_shift_right = {1'b0, in[3:1]};

    // Rotate left by 1 for wrap-around neighbors (for out_different)
    wire [3:0] in_rotate_left = {in[2:0], in[3]};

    assign out_both = in & in_shift_left;
    assign out_both[3] = 1'b0;        // no left neighbor for bit 3

    assign out_any = in | in_shift_right;
    assign out_any[0] = 1'b0;         // no right neighbor for bit 0

    assign out_different = in ^ in_rotate_left;

endmodule