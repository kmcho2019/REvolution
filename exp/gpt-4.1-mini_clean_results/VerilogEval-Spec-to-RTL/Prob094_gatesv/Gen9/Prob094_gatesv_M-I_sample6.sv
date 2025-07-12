module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0
    // Shift in left by 1 (drop MSB), pad LSB with 0 to align for & 
    wire [3:0] in_left_shift = {in[2:0], 1'b0};
    assign out_both = in & in_left_shift;
    assign out_both[3] = 1'b0; // explicitly zero MSB as no left neighbor

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0
    // Shift in right by 1 (drop LSB), pad MSB with 0 to align for | 
    wire [3:0] in_right_shift = {1'b0, in[3:1]};
    assign out_any = in | in_right_shift;
    assign out_any[0] = 1'b0; // explicitly zero LSB as no right neighbor

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // Implement wrap-around by rotating in left by 1
    wire [3:0] in_rotate_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rotate_left;

endmodule