module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // For out_both: each bit indicates if both that bit and its left neighbor (i+1) are 1
    // Shift input left by 1 (pad LSB with 0), then AND with original input.
    // The MSB (bit 99) has no left neighbor, so out_both[99] = 0.
    assign out_both = (in & {in[98:0], 1'b0});

    // For out_any: each bit indicates if either that bit or its right neighbor (i-1) is 1
    // Shift input right by 1 (pad MSB with 0), then OR with original input.
    // The LSB (bit 0) has no right neighbor, so out_any[0] = 0.
    assign out_any = (in | {1'b0, in[99:1]}) & ~100'b1; // Mask LSB to zero

    // For out_different: each bit indicates if that bit differs from its left neighbor (with wrap-around)
    // Create rotated vector to get left neighbors: left neighbor of in[i] is in[(i+1)%100]
    // Rotation is done by concatenation: left neighbor vector = {in[98:0], in[99]}
    wire [99:0] left_neighbors = {in[98:0], in[99]};
    assign out_different = in ^ left_neighbors;

endmodule