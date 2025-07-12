module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Left neighbors (shift right with 0 pad for MSB)
    wire [99:0] left_neighbor = {1'b0, in[99:1]};
    
    // Right neighbors (shift left with 0 pad for LSB)
    wire [99:0] right_neighbor = {in[98:0], 1'b0};
    
    // Circular left neighbor for wrap-around
    wire [99:0] circular_left = {in[0], in[99:1]};

    // out_both: AND with left neighbor (MSB gets 0)
    assign out_both = in & left_neighbor;
    
    // out_any: OR with right neighbor (LSB gets 0)
    assign out_any = in | right_neighbor;
    
    // out_different: XOR with circular left neighbor
    assign out_different = in ^ circular_left;

endmodule