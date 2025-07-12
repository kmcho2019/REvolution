module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift left by 1 to align left neighbors; MSB has no left neighbor
    wire [3:0] in_left = {in[2:0], 1'b0};
    // Shift right by 1 to align right neighbors; LSB has no right neighbor
    wire [3:0] in_right = {1'b0, in[3:1]};

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0 (no left neighbor)
    assign out_both = in & in_left;
    assign out_both[3] = 1'b0; // mask MSB

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0 (no right neighbor)
    assign out_any = in | in_right;
    assign out_any[0] = 1'b0; // mask LSB

    // For out_different, neighbor to the left with wrap-around:
    // Create a rotated version of in by 1 to the left
    wire [3:0] in_left_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_left_rot;

endmodule