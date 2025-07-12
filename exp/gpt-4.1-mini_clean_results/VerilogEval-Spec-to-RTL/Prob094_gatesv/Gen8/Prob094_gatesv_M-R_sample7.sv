module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3] = 0
    // Shift 'in' left by 1 bit, zero pad LSB
    wire [3:0] in_left = {in[2:0], 1'b0};
    assign out_both = in & in_left;
    // Ensure out_both[3] = 0 as in_left[3] is 0

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0] = 0
    // Shift 'in' right by 1 bit, zero pad MSB
    wire [3:0] in_right = {1'b0, in[3:1]};
    assign out_any = in | in_right;
    // out_any[0] = in[0] | in_right[0] = in[0] | 0 = in[0], 
    // but requirement says out_any[0] = 0, so override
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 4], implemented by rotating 'in' left by 1
    wire [3:0] in_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_rot;

endmodule