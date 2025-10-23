module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions of the input
    wire [99:0] in_left_shifted = {in[98:0], 1'b0};  // Shift left (MSB first)
    wire [99:0] in_right_shifted = {1'b0, in[99:1]}; // Shift right (LSB first)
    wire [99:0] in_circular_shifted = {in[0], in[99:1]}; // Circular right shift

    // out_both: AND with left neighbor (except MSB)
    assign out_both = in & in_left_shifted;
    assign out_both[99] = 1'b0;  // Special case for MSB

    // out_any: OR with right neighbor (except LSB)
    assign out_any = in | in_right_shifted;
    assign out_any[0] = 1'b0;    // Special case for LSB

    // out_different: XOR with circular left neighbor
    assign out_different = in ^ in_circular_shifted;

endmodule