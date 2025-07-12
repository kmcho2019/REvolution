module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions
    wire [99:0] left_shifted = {in[98:0], 1'b0};  // Shift left (MSB gets 0)
    wire [99:0] right_shifted = {1'b0, in[99:1]}; // Shift right (LSB gets 0)
    wire [99:0] circular_left = {in[98:0], in[99]}; // Circular left shift

    // Mask for edge cases
    wire [99:0] both_mask = {1'b0, {99{1'b1}}};
    wire [99:0] any_mask = {{99{1'b1}}, 1'b0};

    // Compute outputs
    assign out_both = (in & left_shifted) & both_mask;
    assign out_any = (in | right_shifted) & any_mask;
    assign out_different = in ^ circular_left;

endmodule