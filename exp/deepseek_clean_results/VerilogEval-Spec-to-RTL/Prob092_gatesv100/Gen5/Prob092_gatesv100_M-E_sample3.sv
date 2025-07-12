module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create left-shifted version (circular shift)
    wire [99:0] in_left = {in[98:0], in[99]};

    // out_both: AND with left neighbor (circular)
    assign out_both = in & in_left;

    // out_any: OR with right neighbor (circular)
    // Right neighbor is equivalent to left shift of others
    assign out_any = in | {in[0], in[99:1]};

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ in_left;

endmodule