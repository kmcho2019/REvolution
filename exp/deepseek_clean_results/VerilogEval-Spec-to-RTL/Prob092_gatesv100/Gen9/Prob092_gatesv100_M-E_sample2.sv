module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Shift register approach
wire [99:0] shifted_right = {1'b0, in[99:1]};  // Right shift (for out_both)
wire [99:0] shifted_left = {in[98:0], 1'b0};   // Left shift (for out_any)
wire [99:0] rotated_left = {in[98:0], in[99]}; // Circular left shift (for out_different)

// Output assignments
assign out_both = in & shifted_right;          // AND with right neighbor
assign out_any = in | shifted_left;            // OR with left neighbor
assign out_different = in ^ rotated_left;      // XOR with circular left neighbor

endmodule