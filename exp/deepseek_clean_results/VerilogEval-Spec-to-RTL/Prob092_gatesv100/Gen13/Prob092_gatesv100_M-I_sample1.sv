module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions of input for neighbor operations
    wire [99:0] left_neighbor = {in[98:0], 1'b0};  // Left neighbor (MSB gets 0)
    wire [99:0] right_neighbor = {1'b0, in[99:1]}; // Right neighbor (LSB gets 0)
    
    // out_both: current AND left neighbor (MSB forced to 0)
    assign out_both = in & left_neighbor;
    assign out_both[99] = 1'b0;  // Explicitly set MSB to 0
    
    // out_any: current OR right neighbor (LSB forced to 0)
    assign out_any = in | right_neighbor;
    assign out_any[0] = 1'b0;    // Explicitly set LSB to 0
    
    // out_different: current XOR left neighbor with circular wrap
    wire [99:0] circular_left = {in[0], in[99:1]};  // Circular left shift
    assign out_different = in ^ circular_left;

endmodule