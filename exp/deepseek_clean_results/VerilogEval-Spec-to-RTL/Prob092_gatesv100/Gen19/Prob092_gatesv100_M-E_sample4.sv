module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND with left neighbor (MSB = 0)
    wire [99:0] in_left_shift = {in[98:0], 1'b0};
    assign out_both = in & in_left_shift;
    assign out_both[99] = 1'b0;  // Explicitly set MSB to 0

    // out_any: OR with right neighbor (LSB = 0)
    wire [99:0] in_right_shift = {1'b0, in[99:1]};
    assign out_any = in | in_right_shift;
    assign out_any[0] = 1'b0;    // Explicitly set LSB to 0

    // out_different: XOR with left neighbor (wrap-around)
    wire [99:0] in_left_wrap = {in[98:0], in[99]};
    assign out_different = in ^ in_left_wrap;

endmodule