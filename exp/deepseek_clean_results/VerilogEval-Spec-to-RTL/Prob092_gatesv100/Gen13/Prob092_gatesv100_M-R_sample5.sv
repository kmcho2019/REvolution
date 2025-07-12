module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create left-shifted version of input (for left neighbor operations)
    wire [99:0] in_left = {in[98:0], in[99]};  // Circular left shift
    
    // Create right-shifted version of input (for right neighbor operations)
    wire [99:0] in_right = {in[0], in[99:1]};  // Circular right shift

    // out_both: current AND left neighbor (except MSB)
    assign out_both = {1'b0, in[98:0] & in[99:1]};
    
    // out_any: current OR right neighbor (except LSB)
    assign out_any = {in[99:1] | in[98:0], 1'b0};
    
    // out_different: current XOR left neighbor (circular)
    assign out_different = in ^ in_left;

endmodule