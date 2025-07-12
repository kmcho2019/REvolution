module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift in left by 1 bit, padding LSB with 0, to get the left neighbor bits
    wire [3:0] left_neighbor = {in[2:0], 1'b0};

    // Shift in right by 1 bit, padding MSB with 0, to get the right neighbor bits
    wire [3:0] right_neighbor = {1'b0, in[3:1]};

    // out_both: both bit and left neighbor are '1'
    // For in[3], left_neighbor is 0, so out_both[3] = 0 implicitly
    assign out_both = in & left_neighbor;

    // out_any: either bit or right neighbor are '1'
    // For in[0], right neighbor is 0, so out_any[0] = in[0] | 0 = in[0],
    // but problem says out_any[0] is 0 since no right neighbor. So we force it explicitly:
    assign out_any = (in | right_neighbor) & 4'b1110; // mask out_any[0] = 0

    // out_different: bit different from left neighbor with wrap-around
    // Rotate left by 1 bit to get left neighbor with wrap-around
    wire [3:0] left_neighbor_wrapped = {in[2:0], in[3]};
    assign out_different = in ^ left_neighbor_wrapped;

endmodule