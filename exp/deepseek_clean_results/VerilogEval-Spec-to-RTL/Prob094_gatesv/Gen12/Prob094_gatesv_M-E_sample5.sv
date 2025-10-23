module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Left-shifted version for out_both (pad with 0)
    wire [3:0] left_shifted = {in[2:0], 1'b0};
    
    // Right-shifted version for out_any (pad with 0)
    wire [3:0] right_shifted = {1'b0, in[3:1]};
    
    // Circular left-shifted version for out_different
    wire [3:0] circular_left = {in[2:0], in[3]};
    
    // Compute outputs using bitwise operations
    assign out_both = in & left_shifted;
    assign out_any = in | right_shifted;
    assign out_different = in ^ circular_left;
    
    // Explicitly set unused bits to 0
    assign out_both[3] = 1'b0;
    assign out_any[0] = 1'b0;

endmodule