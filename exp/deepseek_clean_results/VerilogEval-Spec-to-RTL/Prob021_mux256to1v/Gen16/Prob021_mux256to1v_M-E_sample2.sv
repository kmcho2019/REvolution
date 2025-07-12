module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the shift amount (0-1020 in steps of 4)
    wire [9:0] shift_amount = {sel, 2'b00}; // sel * 4
    
    // Create the rotated version of the input
    wire [1023:0] rotated_in = (in >> shift_amount) | (in << (1024 - shift_amount));
    
    // Output is the first 4 bits of the rotated input
    assign out = rotated_in[3:0];
endmodule