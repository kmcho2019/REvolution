module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift left by 1 bit to get left neighbors (with 0 padding)
    wire [3:0] left_neighbors = {in[2:0], 1'b0};
    // out_both: bitwise AND with left neighbors; out_both[3] = 0 automatically
    assign out_both = in & left_neighbors;

    // Shift right by 1 bit to get right neighbors (with 0 padding)
    wire [3:0] right_neighbors = {1'b0, in[3:1]};
    // out_any: bitwise OR with right neighbors; out_any[0] = 0 automatically
    assign out_any = in | right_neighbors;

    // Rotate input left by 1 bit to get wrap-around left neighbor
    wire [3:0] rotated_left = {in[2:0], in[3]};
    // out_different: XOR with rotated vector for wrap-around difference
    assign out_different = in ^ rotated_left;

endmodule