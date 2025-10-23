module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions of the input
    wire [99:0] left_shifted = {in[98:0], 1'b0};  // Left shift with 0 pad
    wire [99:0] right_shifted = {1'b0, in[99:1]}; // Right shift with 0 pad
    wire [99:0] circular_left = {in[98:0], in[99]}; // Circular left shift

    // out_both: AND with left-shifted version (mask MSB)
    assign out_both = in & left_shifted;
    assign out_both[99] = 1'b0;  // Explicitly set MSB to 0

    // out_any: OR with right-shifted version (mask LSB)
    assign out_any = in | right_shifted;
    assign out_any[0] = 1'b0;    // Explicitly set LSB to 0

    // out_different: XOR with circular left shift
    assign out_different = in ^ circular_left;

endmodule