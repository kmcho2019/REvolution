module TopModule(
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: neighbor to the left (higher index) AND with current bit
    // shift input left by 1 bit, bit 0 zero-padded
    wire [3:0] in_shift_left = {in[2:0], 1'b0};
    assign out_both = in & in_shift_left;
    // out_both[3] corresponds to in[3] & in[4], in[4] doesn't exist, so cleared by zero-padding

    // out_any: neighbor to the right (lower index) OR with current bit
    // shift input right by 1 bit, bit 3 zero-padded
    wire [3:0] in_shift_right = {1'b0, in[3:1]};
    assign out_any = in | in_shift_right;
    // out_any[0] = in[0] | in[-1] (nonexistent), zero-padded via shift

    // out_different: XOR current bit with neighbor to the left with wrap-around
    // wrap-around neighbor is (i+1) mod 4; rotate input left by 1 bit
    wire [3:0] in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule