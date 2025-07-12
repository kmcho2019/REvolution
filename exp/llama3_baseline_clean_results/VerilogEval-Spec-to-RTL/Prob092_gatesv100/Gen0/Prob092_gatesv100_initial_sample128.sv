module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
assign out_both[99] = 1'b0;  // No neighbour to the left for the leftmost bit
assign out_both[98:0] = in[98:0] & {1'b0, in[99:1]};

// Generate out_any
assign out_any[0] = 1'b0;  // No neighbour to the right for the rightmost bit
assign out_any[99:1] = in[99:1] | {in[98:0], 1'b0};

// Generate out_different
assign out_different = in ^ {in[0], in[99:1]};

endmodule