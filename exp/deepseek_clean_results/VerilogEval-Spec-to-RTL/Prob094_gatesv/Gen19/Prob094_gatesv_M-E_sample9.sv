module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create left-shifted version for neighbor comparisons
    wire [3:0] left_shifted = {in[2:0], 1'b0};
    
    // Create circular left-shifted version for wrap-around
    wire [3:0] circular_shifted = {in[2:0], in[3]};
    
    // Calculate out_both (AND with left neighbor)
    assign out_both = {1'b0, in[2:0] & in[3:1]};
    
    // Calculate out_any (OR with right neighbor)
    assign out_any = {in[3:1] | in[2:0], 1'b0};
    
    // Calculate out_different (XOR with circular left neighbor)
    assign out_different = in ^ circular_shifted;

endmodule