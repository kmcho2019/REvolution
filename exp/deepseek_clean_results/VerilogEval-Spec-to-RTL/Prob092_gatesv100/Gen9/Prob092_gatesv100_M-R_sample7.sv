module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Left neighbor for out_both (non-circular)
    wire [99:0] left_for_both = {1'b0, in[99:1]};
    
    // Right neighbor for out_any (non-circular)
    wire [99:0] right_for_any = {in[98:0], 1'b0};
    
    // Circular left neighbor for out_different
    wire [99:0] left_for_diff = {in[0], in[99:1]};

    // Compute outputs
    assign out_both[99:0] = in & left_for_both;  // MSB automatically 0
    assign out_any[99:0] = in | right_for_any;   // LSB automatically 0
    assign out_different = in ^ left_for_diff;    // Full circular comparison

endmodule