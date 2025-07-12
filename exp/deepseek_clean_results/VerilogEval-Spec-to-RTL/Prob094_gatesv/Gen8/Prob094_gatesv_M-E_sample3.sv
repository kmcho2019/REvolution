module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] left_neighbor  = {in[2:0], 1'b0};  // Shift left (higher index is left)
    wire [3:0] right_neighbor = {1'b0, in[3:1]}; // Shift right
    wire [3:0] rotated_left   = {in[0], in[3:1]}; // For circular difference

    // out_both: AND with left neighbor (mask MSB since no left neighbor)
    assign out_both = (in & left_neighbor) & 4'b0111;

    // out_any: OR with right neighbor (mask LSB since no right neighbor)
    assign out_any = (in | right_neighbor) & 4'b1110;

    // out_different: XOR with rotated version (circular)
    assign out_different = in ^ rotated_left;

endmodule