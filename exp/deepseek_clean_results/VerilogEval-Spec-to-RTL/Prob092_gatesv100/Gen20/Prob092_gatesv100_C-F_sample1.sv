module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: Each bit indicates if current bit AND left neighbor are both 1
    // Bit 99 is always 0 (no left neighbor)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: Each bit indicates if current bit OR right neighbor is 1
    // Bit 0 is always 0 (no right neighbor)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: Each bit indicates if current bit XOR left neighbor (wrapped)
    // Uses circular left neighbor (bit 0 is left neighbor of bit 99)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule