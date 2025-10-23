module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Rotate left by 1: MSB wraps around to LSB
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    // Rotate right by 1: LSB wraps around to MSB
    wire [99:0] in_rot_right = {in[0], in[99:1]};

    // out_both[i] = in[i] & in[i+1], left neighbor is rotate left by 1
    wire [99:0] temp_both = in & in_rot_left;
    assign out_both = {temp_both[99:1], 1'b0}; // clear bit 0 (index 99 to left is none, so set out_both[99]=0)

    // out_any[i] = in[i] | in[i-1], right neighbor is rotate right by 1
    wire [99:0] temp_any = in | in_rot_right;
    assign out_any = {1'b0, temp_any[99:1]}; // clear out_any[0]=0 as specified

    // out_different[i] = in[i] ^ in[(i+1)%100], neighbor to left with wrap-around is rotate left
    assign out_different = in ^ in_rot_left;

endmodule