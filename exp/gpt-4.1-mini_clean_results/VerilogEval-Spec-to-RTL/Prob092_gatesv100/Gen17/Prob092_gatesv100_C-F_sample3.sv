module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], except out_both[99] = 0 (no left neighbor)
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99]    = 1'b0;

    // out_any[i] = in[i] | in[i-1], except out_any[0] = 0 (no right neighbor)
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0]    = 1'b0;

    // For out_different: each bit compares in[i] with left neighbor in[i+1], with wrap-around so neighbor of in[99] is in[0].
    // Create a left neighbor vector with wrap-around by concatenation
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule