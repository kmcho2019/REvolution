module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular left shift of input (for neighbor comparisons)
    wire [3:0] shifted_in = {in[0], in[3:1]};
    
    // Mask for edge cases (bit 3 for out_both, bit 0 for out_any)
    wire [3:0] both_mask = 4'b0111;
    wire [3:0] any_mask = 4'b1110;
    
    // Unified neighbor processing
    assign out_both = (in & shifted_in) & both_mask;
    assign out_any = (in | shifted_in) & any_mask;
    assign out_different = in ^ shifted_in;

endmodule