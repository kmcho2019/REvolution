module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3]=0
    // shift in left by 1 and AND, mask out bit 3
    wire [3:0] in_shifted_left = {in[2:0], 1'b0};
    assign out_both = (in & in_shifted_left) & 4'b0111;

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0]=0
    // shift in right by 1 and OR, mask out bit 0
    wire [3:0] in_shifted_right = {1'b0, in[3:1]};
    assign out_any = (in | in_shifted_right) & 4'b1110;

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    // rotate in left by 1 (wrap-around) and XOR
    wire [3:0] in_rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rotated_left;

endmodule