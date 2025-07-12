module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift input left by 1 bit, LSB zero-padded: neighbors to the left for bits 0-2, bit 3 has no neighbor
    wire [3:0] left_neighbor = {in[2:0], 1'b0};
    assign out_both = in & left_neighbor;  // out_both[3] = 0 automatically

    // Shift input right by 1 bit, MSB zero-padded: neighbors to the right for bits 1-3, bit 0 has no neighbor
    wire [3:0] right_neighbor = {1'b0, in[3:1]};
    assign out_any = in | right_neighbor;  // out_any[0] = 0 automatically

    // Rotate left by 1 bit (wrap-around) for neighbors to the left with wrap-around
    wire [3:0] rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ rotated_left;

endmodule