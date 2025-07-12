module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shared rotated input vector
    wire [99:0] rotated_in = {in[0], in[99:1]};

    // out_both: AND with left neighbor (bit 99 isolated)
    assign out_both = {1'b0, in[98:0] & rotated_in[98:0]};

    // out_any: OR with right neighbor (bit 0 isolated)
    assign out_any = {in[99:1] | rotated_in[99:1], 1'b0};

    // out_different: XOR with left neighbor (wrapped)
    assign out_different = in ^ rotated_in;

endmodule