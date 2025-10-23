module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create shifted versions of the input
    wire [3:0] left_shifted = {in[2:0], 1'b0};      // Left shift (for left neighbors)
    wire [3:0] right_shifted = {1'b0, in[3:1]};     // Right shift (for right neighbors)
    wire [3:0] circular_left = {in[2:0], in[3]};    // Circular left shift (for wrap-around)

    // out_both: AND with left-shifted version (ignore MSB)
    assign out_both = in & left_shifted;

    // out_any: OR with right-shifted version (ignore LSB)
    assign out_any = in | right_shifted;

    // out_different: XOR with circular left-shifted version
    assign out_different = in ^ circular_left;

endmodule