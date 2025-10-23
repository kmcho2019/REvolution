module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Shift left (higher indices to left)
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Shift right (lower indices to right)
    wire [3:0] rotated_left = {in[0], in[3:1]}; // Rotate left for wrap-around

    // out_both: AND with left-shifted version (mask MSB)
    assign out_both = in & left_shifted;
    assign out_both[3] = 1'b0;  // MSB has no left neighbor

    // out_any: OR with right-shifted version (mask LSB)
    assign out_any = in | right_shifted;
    assign out_any[0] = 1'b0;   // LSB has no right neighbor

    // out_different: XOR with rotated version
    assign out_different = in ^ rotated_left;

endmodule