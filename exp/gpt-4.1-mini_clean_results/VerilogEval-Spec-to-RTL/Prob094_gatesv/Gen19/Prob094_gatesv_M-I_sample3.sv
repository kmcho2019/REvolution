module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0
    wire [3:0] in_shift_left = {in[2:0], 1'b0}; // shifted left by 1 with zero at LSB
    assign out_both = in & in_shift_left;
    assign out_both[3] = 1'b0; // explicitly zero as per spec

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0
    wire [3:0] in_shift_right = {1'b0, in[3:1]}; // shifted right by 1 with zero at MSB
    assign out_any = in | in_shift_right;
    assign out_any[0] = 1'b0; // explicitly zero as per spec

    // out_different[i] = in[i] ^ in[(i+1) mod 4] (left neighbor wraps around)
    // Rotate in left by 1 bit to get left neighbors
    wire [3:0] in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule