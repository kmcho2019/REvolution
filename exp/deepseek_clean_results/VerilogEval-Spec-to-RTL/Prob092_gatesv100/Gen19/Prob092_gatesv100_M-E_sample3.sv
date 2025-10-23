module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] right_shifted = {in[0], in[99:1]};  // Circular right shift
    wire [99:0] left_shifted = {in[98:0], in[99]};  // Circular left shift

    // out_both: AND with right neighbor (circular right shift)
    assign out_both = in & right_shifted;
    assign out_both[99] = 1'b0;  // Special case for MSB

    // out_any: OR with left neighbor (circular left shift)
    assign out_any = in | left_shifted;
    assign out_any[0] = 1'b0;    // Special case for LSB

    // out_different: XOR with right neighbor (circular right shift)
    assign out_different = in ^ right_shifted;

endmodule