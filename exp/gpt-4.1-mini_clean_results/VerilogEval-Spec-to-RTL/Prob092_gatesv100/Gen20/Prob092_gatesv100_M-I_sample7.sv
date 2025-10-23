module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: 1 if both in[i] and its left neighbor in[i+1] are 1 for i=0..98
    // For i=99, no left neighbor, so set to 0
    assign out_both = {1'b0, (in[98:0] & in[99:1])};

    // out_any[i]: 1 if either in[i] or its right neighbor in[i-1] is 1 for i=1..99
    // For i=0, no right neighbor, so set to 0
    assign out_any  = {(in[99:1] | in[98:0]), 1'b0};

    // out_different[i]: 1 if in[i] differs from its left neighbor with wrap-around
    // Left neighbor vector with wrap-around: neighbor of in[99] is in[0]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule