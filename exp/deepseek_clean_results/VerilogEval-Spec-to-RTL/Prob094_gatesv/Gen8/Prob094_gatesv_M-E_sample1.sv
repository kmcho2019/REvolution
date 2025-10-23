module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Temporary wires for shifted versions
    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Shift left (higher index is left)
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Shift right
    wire [3:0] circular_left = {in[2:0], in[3]}; // Circular shift left

    // out_both: AND with left neighbor (ignore MSB)
    assign out_both = {1'b0, in[2:0] & left_shifted[2:0]};

    // out_any: OR with right neighbor (ignore LSB)
    assign out_any = {in[3:1] | right_shifted[3:1], 1'b0};

    // out_different: XOR with circular left shift
    assign out_different = in ^ circular_left;

endmodule