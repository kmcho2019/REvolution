module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular right shift for neighbor-left operations
    wire [99:0] shifted_right = {in[0], in[99:1]};
    
    // Circular left shift for neighbor-right operations
    wire [99:0] shifted_left = {in[98:0], in[99]};
    
    // out_both: AND with right neighbor (mask MSB)
    assign out_both = in & shifted_right & {1'b0, {99{1'b1}}};
    
    // out_any: OR with left neighbor (mask LSB)
    assign out_any = in | shifted_left & {{99{1'b1}}, 1'b0};
    
    // out_different: XOR with right neighbor (full circular)
    assign out_different = in ^ shifted_right;

endmodule