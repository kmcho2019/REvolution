module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: '1' if in[i] and its left neighbor in[i+1] are both '1'.
    // For i=0..98: neighbor to the left is in[i+1].
    // For i=99: no neighbor to the left, so out_both[99] = 0.
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i]: '1' if in[i] or its right neighbor in[i-1] is '1'.
    // For i=1..99: neighbor to the right is in[i-1].
    // For i=0: no neighbor to the right, so out_any[0] = 0.
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i]: '1' if in[i] differs from its left neighbor.
    // Left neighbor of in[99] is in[0] (wrap-around).
    // Implement wrap-around via concatenation.
    assign out_different = in ^ {in[0], in[99:1]};

endmodule