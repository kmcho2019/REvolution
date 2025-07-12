module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Create a double-width version of the input for rotation
    wire [2047:0] rotated_input = {in, in};
    
    // Calculate the rotated position (sel*4 bits)
    wire [10:0] rotate_amount = {sel, 2'b00}; // Multiply sel by 4
    
    // Select the rotated window and pick the first 4 bits
    assign out = rotated_input[rotate_amount +: 4];
endmodule