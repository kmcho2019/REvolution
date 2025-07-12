module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Create a double-width version of input for rotation
    wire [2047:0] double_in = {in, in};
    
    // Calculate the rotation amount (sel*4)
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Perform the rotation and mask to get the output
    assign out = double_in[shift_amount +: 4];
endmodule