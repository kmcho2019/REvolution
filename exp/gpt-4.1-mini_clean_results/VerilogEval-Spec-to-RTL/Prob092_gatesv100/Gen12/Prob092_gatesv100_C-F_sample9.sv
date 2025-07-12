module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: 1 if both in[i] and its left neighbor in[i+1] are '1', for i=0 to 98
    // out_both[99]: no left neighbor, assign 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i]: 1 if either in[i] or its right neighbor in[i-1] is '1', for i=1 to 99
    // out_any[0]: no right neighbor, assign 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i]: 1 if in[i] differs from its left neighbor, wrapping around at edges
    // wrap-around implemented by concatenating in[0] at LSB with in[99:1] shifted
    assign out_different = in ^ {in[0], in[99:1]};

endmodule