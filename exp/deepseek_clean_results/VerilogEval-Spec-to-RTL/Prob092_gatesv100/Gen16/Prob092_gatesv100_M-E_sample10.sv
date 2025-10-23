module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular right shift for left neighbors
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    
    // Circular left shift for right neighbors
    wire [99:0] right_neighbor = {in[98:0], in[99]};
    
    // out_both: AND with left neighbor (except MSB)
    assign out_both = {1'b0, in[98:0] & left_neighbor[98:0]};
    
    // out_any: OR with right neighbor (except LSB)
    assign out_any = {in[99:1] | right_neighbor[99:1], 1'b0};
    
    // out_different: XOR with left neighbor (full circular)
    assign out_different = in ^ left_neighbor;

endmodule