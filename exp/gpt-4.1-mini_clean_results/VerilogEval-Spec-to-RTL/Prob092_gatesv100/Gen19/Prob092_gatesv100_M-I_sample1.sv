module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Neighbors to the left (shift input left by 1 with zero padding at LSB)
    wire [99:0] neighbor_left = {in[98:0], 1'b0};
    // Neighbors to the right (shift input right by 1 with zero padding at MSB)
    wire [99:0] neighbor_right = {1'b0, in[99:1]};

    // out_both[i] = in[i] & in[i+1] for i=0..98
    // Because in[i+1] is neighbor to left for bit i
    // With neighbor_left aligned as in[99:1] for bits 0..98, bit 99 zero
    assign out_both = in & neighbor_left;
    assign out_both[99] = 1'b0; // explicitly zero out the last bit

    // out_any[i] = in[i] | in[i-1] for i=1..99
    // neighbor_right has in[i-1] aligned at bit i
    assign out_any = in | neighbor_right;
    assign out_any[0] = 1'b0; // zero out first bit with no right neighbor

    // out_different[i] = in[i] ^ in[(i-1) mod 100]
    // neighbor to left with wrap-around: for bit 99, neighbor is in[0]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule