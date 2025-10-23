module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create left neighbor vector by left shifting in by 1 and zero padding LSB
    wire [3:0] left_neighbor = {in[2:0], 1'b0};

    // Create right neighbor vector by right shifting in by 1 and zero padding MSB
    wire [3:0] right_neighbor = {1'b0, in[3:1]};

    // out_both[i] = in[i] & left_neighbor[i], except out_both[3]=0 since in[3] has no left neighbor
    assign out_both = (in & left_neighbor) & 4'b0111; // mask off bit 3

    // out_any[i] = in[i] | right_neighbor[i], except out_any[0]=0 since in[0] has no right neighbor
    assign out_any = (in | right_neighbor) & 4'b1110; // mask off bit 0

    // out_different[i] = in[i] ^ circular_left_shift(in,1)
    wire [3:0] circular_left = {in[2:0], in[3]};
    assign out_different = in ^ circular_left;

endmodule