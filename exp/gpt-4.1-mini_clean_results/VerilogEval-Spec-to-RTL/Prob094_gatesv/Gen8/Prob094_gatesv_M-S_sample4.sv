module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] in_left  = {in[2:0], 1'b0}; // shifted left by 1, last bit zero
    wire [3:0] in_right = {1'b0, in[3:1]}; // shifted right by 1, first bit zero
    wire [3:0] in_rot   = {in[2:0], in[3]}; // rotate left by 1

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0
    assign out_both = in & in_left;

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0
    assign out_any = in | in_right;

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ in_rot;

endmodule