module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: AND with left neighbor (in shifted left by 1)
    // bit 3 has no left neighbor, so set to 0
    assign out_both = (in & {in[2:0], 1'b0});

    // out_any: OR with right neighbor (in shifted right by 1)
    // bit 0 has no right neighbor, so set to 0
    assign out_any = (in | {1'b0, in[3:1]}) & 4'b1110;

    // out_different: XOR with left neighbor with wrap-around (circular left shift by 1)
    wire [3:0] rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ rotated_left;

endmodule