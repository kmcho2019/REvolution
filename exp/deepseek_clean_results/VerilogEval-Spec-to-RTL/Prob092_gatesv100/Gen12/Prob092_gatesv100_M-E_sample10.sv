module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions of the input
    wire [99:0] left_shifted = {in[98:0], 1'b0};  // For out_both (left neighbor)
    wire [99:0] right_shifted = {1'b0, in[99:1]}; // For out_any (right neighbor)
    wire [99:0] circular_left = {in[98:0], in[99]}; // For out_different (wrap-around)

    // Generate outputs
    assign out_both = in & left_shifted;
    assign out_any = in | right_shifted;
    assign out_different = in ^ circular_left;

    // Handle edge cases explicitly (though they're already handled by shifts)
    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;

endmodule