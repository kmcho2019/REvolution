module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left shift of input (for neighbor access)
    wire [99:0] shifted_in = {in[98:0], in[99]};

    // out_both: AND with left neighbor (bit 99 = 0)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: OR with right neighbor (bit 0 = 0)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ shifted_in;

endmodule