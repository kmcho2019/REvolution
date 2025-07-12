module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate shift amount (sel*4) with 10-bit precision to handle full range
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Create extended input for circular rotation (double the size for shifting)
    wire [2047:0] extended_in = {in, in};
    
    // Perform the barrel shift and extract the rotated LSBs
    assign out = extended_in[shift_amount +: 4];

endmodule