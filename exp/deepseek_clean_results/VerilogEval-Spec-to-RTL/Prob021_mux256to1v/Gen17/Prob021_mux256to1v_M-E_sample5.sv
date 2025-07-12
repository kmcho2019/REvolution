module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate rotation amount (sel * 4)
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Create circular rotation of input vector
    wire [1023:0] rotated_in = (in >> shift_amount) | (in << (1024 - shift_amount));
    
    // Output is the first 4 bits after rotation
    assign out = rotated_in[3:0];

endmodule