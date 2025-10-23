module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // For out_both[i], check in[i] & in[i+1], for i=0..2; out_both[3]=0 (no neighbor to left)
    // Create shifted left neighbor vector: in shifted left by 1 bit, with LSB zero padded
    wire [3:0] in_left = {in[2:0], 1'b0};
    assign out_both = in & in_left;

    // For out_any[i], check in[i] | in[i-1], for i=1..3; out_any[0] = 0 (no neighbor to right)
    // Create shifted right neighbor vector: in shifted right by 1 bit, with MSB zero padded
    wire [3:0] in_right = {1'b0, in[3:1]};
    assign out_any = in | in_right;
    assign out_any[0] = 1'b0;  // Explicit zero for bit 0 per spec

    // For out_different[i], check in[i] ^ in[(i+1)%4] (wrap-around)
    // Rotate in left by 1 bit to get neighbors with wrap-around
    wire [3:0] in_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_rot;

endmodule