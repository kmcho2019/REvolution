module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both remains optimal as is
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any remains optimal as is
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // Optimized out_different with more efficient wrap-around
    wire [99:0] in_rotated = {in[0], in[99:1]};
    assign out_different = in ^ in_rotated;

endmodule