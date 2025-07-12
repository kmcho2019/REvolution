module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with right-shifted version (neighbor to left)
    wire [3:0] shifted_for_both = {in[2:0], 1'b0};
    assign out_both = in & shifted_for_both;
    assign out_both[3] = 1'b0;  // Mask unused bit

    // out_any: OR with left-shifted version (neighbor to right)
    wire [3:0] shifted_for_any = {1'b0, in[3:1]};
    assign out_any = in | shifted_for_any;
    assign out_any[0] = 1'b0;   // Mask unused bit

    // out_different: XOR with circular left-shifted version
    wire [3:0] circular_shift = {in[0], in[3:1]};
    assign out_different = in ^ circular_shift;

endmodule