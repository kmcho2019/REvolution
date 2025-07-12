module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shift registers for neighbor operations
    wire [99:0] shifted_left = {in[98:0], 1'b0};  // Left shift (LSB filled with 0)
    wire [99:0] shifted_right = {1'b0, in[99:1]}; // Right shift (MSB filled with 0)
    wire [99:0] circular_left = {in[98:0], in[99]}; // Circular left shift

    // out_both: AND with left-shifted version
    assign out_both = in & shifted_left;
    assign out_both[99] = 1'b0;  // Explicitly set MSB to 0

    // out_any: OR with right-shifted version
    assign out_any = in | shifted_right;
    assign out_any[0] = 1'b0;    // Explicitly set LSB to 0

    // out_different: XOR with circular left-shifted version
    assign out_different = in ^ circular_left;

endmodule