module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] right_shifted = {1'b0, in[3:1]};  // Right shift (LSB filled with 0)
    wire [3:0] left_shifted = {in[2:0], 1'b0};   // Left shift (MSB filled with 0)
    wire [3:0] circular_left = {in[2:0], in[3]}; // Circular left shift

    // out_both: AND with right neighbor (except MSB)
    assign out_both = in & right_shifted;

    // out_any: OR with left neighbor (except LSB)
    assign out_any = in | left_shifted;

    // out_different: XOR with circular left neighbor
    assign out_different = in ^ circular_left;

endmodule