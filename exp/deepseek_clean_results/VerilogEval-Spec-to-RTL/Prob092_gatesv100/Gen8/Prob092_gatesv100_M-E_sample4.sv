module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND with left neighbor (shift left by 1)
    wire [99:0] shifted_left = {in[98:0], 1'b0};
    assign out_both = in & shifted_left;
    assign out_both[99] = 1'b0;  // Handle boundary condition

    // out_any: OR with right neighbor (shift right by 1)
    wire [99:0] shifted_right = {1'b0, in[99:1]};
    assign out_any = in | shifted_right;
    assign out_any[0] = 1'b0;    // Handle boundary condition

    // out_different: XOR with circular left shift
    wire [99:0] rotated_left = {in[98:0], in[99]};
    assign out_different = in ^ rotated_left;

endmodule