module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: both in[i] and its left neighbor in[i+1] are '1', for i=0..98
    // out_both[99] = 0 since no left neighbor for in[99]
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i]: either in[i] or its right neighbor in[i-1] is '1', for i=1..99
    // out_any[0] = 0 since no right neighbor for in[0]
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i]: in[i] different from its left neighbor, with wrap-around (neighbor of 99 is 0)
    // Construct left-neighbor vector by concatenating in[0] with in[99:1]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule