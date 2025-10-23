module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate rotation amount (sel*4)
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Create rotated version by concatenating the input with itself
    wire [2047:0] rotated = {in, in} >> shift_amount;
    
    // Output is the least significant 4 bits of rotated version
    assign out = rotated[3:0];

endmodule