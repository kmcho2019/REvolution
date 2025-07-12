module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shifted versions of input for neighbor operations
    wire [99:0] in_left_shifted = {in[0], in[99:1]};  // For left neighbor (wrapped)
    wire [99:0] in_right_shifted = {in[98:0], in[99]}; // For right neighbor (wrapped)

    // out_both: AND with left neighbor (bit 99 = 0)
    assign out_both[99] = 1'b0;  // Special case for MSB
    assign out_both[98:0] = in[98:0] & in[99:1];  // AND with left neighbor

    // out_any: OR with right neighbor (bit 0 = 0)
    assign out_any[0] = 1'b0;  // Special case for LSB
    assign out_any[99:1] = in[99:1] | in[98:0];  // OR with right neighbor

    // out_different: XOR with left neighbor (wrapped)
    assign out_different = in ^ in_left_shifted;  // Wrapped XOR operation

endmodule