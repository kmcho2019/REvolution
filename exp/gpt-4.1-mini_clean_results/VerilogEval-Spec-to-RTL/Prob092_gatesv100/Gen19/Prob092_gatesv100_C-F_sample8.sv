module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] indicates if both in[i] and its neighbor to the left in[i+1] are 1,
    // for i=0..98. Since in[99] has no left neighbor, out_both[99] is set to 0.
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i] indicates if either in[i] or its neighbor to the right in[i-1] is 1,
    // for i=1..99. Since in[0] has no right neighbor, out_any[0] is set to 0.
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] indicates if in[i] is different from its neighbor to the left.
    // The vector is treated as wrap-around, so neighbor of in[99] is in[0].
    // Construct the neighbor vector with wrap-around using concatenation.
    assign out_different = in ^ {in[0], in[99:1]};

endmodule