module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Left-shifted version for out_both (non-circular)
    wire [99:0] left_shifted = {in[98:0], 1'b0};
    
    // Right-shifted version for out_any (non-circular)
    wire [99:0] right_shifted = {1'b0, in[99:1]};
    
    // Circular left-shifted version for out_different
    wire [99:0] circular_left = {in[98:0], in[99]};
    
    // out_both calculation
    assign out_both = in & left_shifted;
    assign out_both[99] = 1'b0;  // No left neighbor for MSB
    
    // out_any calculation
    assign out_any = in | right_shifted;
    assign out_any[0] = 1'b0;    // No right neighbor for LSB
    
    // out_different calculation
    assign out_different = in ^ circular_left;

endmodule