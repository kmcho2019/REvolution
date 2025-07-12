module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shifted versions of input
    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Left shift (for out_both)
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Right shift (for out_any)
    wire [3:0] circular_shifted = {in[2:0], in[3]}; // Circular left shift (for out_different)

    // Compute outputs using bitwise operations
    assign out_both = in & left_shifted;        // AND with left neighbor
    assign out_any = in | right_shifted;        // OR with right neighbor
    assign out_different = in ^ circular_shifted; // XOR with circular left neighbor

    // Mask out unused bits (optional but good practice)
    assign out_both[3] = 1'b0;                  // No left neighbor for MSB
    assign out_any[0] = 1'b0;                   // No right neighbor for LSB

endmodule