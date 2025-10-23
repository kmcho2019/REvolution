module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Extract neighbors to the left and right for reuse
    wire [98:0] in_left_neighbors  = in[99:1];  // left neighbor for bits 0..98
    wire [98:0] in_right_neighbors = in[98:0];  // right neighbor for bits 1..99

    // out_both[i] = in[i] & in[i+1] for i=0..98; last bit 99=0 since no left neighbor
    // Using in_left_neighbors as neighbor to left for bits 0..98:
    assign out_both[98:0] = in[98:0] & in_left_neighbors;
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; first bit 0=0 since no right neighbor
    assign out_any[99:1] = in[99:1] | in_right_neighbors;
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i-1) mod 100] with wrap-around
    // Wrap-around neighbor vector constructed once
    wire [99:0] in_left_wrap = {in[0], in[99:1]};
    assign out_different = in ^ in_left_wrap;

endmodule