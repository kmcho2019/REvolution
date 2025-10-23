module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Rotate left by 1: {in[2:0], in[3]}
    wire [3:0] in_rot_left = {in[2:0], in[3]};

    // Left shift by 1: {in[2:0], 0}
    wire [3:0] in_shl1 = {in[2:0], 1'b0};

    // Right shift by 1: {0, in[3:1]}
    wire [3:0] in_shr1 = {1'b0, in[3:1]};

    // out_both[i] = in[i] & in[i+1] (left neighbor)
    // Using left shift and AND, mask MSB out_both[3]=0 since no left neighbor
    assign out_both = (in & in_shl1) & 4'b0111;

    // out_any[i] = in[i] | in[i-1] (right neighbor)
    // Using right shift and OR, mask LSB out_any[0]=0 since no right neighbor
    assign out_any = (in | in_shr1) & 4'b1110;

    // out_different[i] = in[i] ^ in[(i+1)%4] (left neighbor with wrap)
    // Using rotate left and XOR
    assign out_different = in ^ in_rot_left;

endmodule