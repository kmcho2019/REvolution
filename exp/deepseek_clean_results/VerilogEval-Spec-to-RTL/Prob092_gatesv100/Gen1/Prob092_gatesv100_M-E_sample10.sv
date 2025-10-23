module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shifted versions of input
    wire [99:0] shifted_left = {in[98:0], 1'b0};  // Left shift (LSB filled with 0)
    wire [99:0] shifted_right = {1'b0, in[99:1]}; // Right shift (MSB filled with 0)
    wire [99:0] circular_left = {in[98:0], in[99]}; // Circular left shift

    // out_both generation
    assign out_both = (in & shifted_left) & {1'b0, {99{1'b1}}}; // AND with shifted, force MSB to 0

    // out_any generation
    assign out_any = (in | shifted_right) & {{99{1'b1}}, 1'b0}; // OR with shifted, force LSB to 0

    // out_different generation
    assign out_different = in ^ circular_left; // XOR with circular shifted

endmodule