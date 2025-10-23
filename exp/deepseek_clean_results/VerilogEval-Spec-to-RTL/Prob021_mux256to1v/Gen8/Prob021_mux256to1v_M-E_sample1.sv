module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Compute shift amount (sel*4)
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Barrel shift right by shift_amount bits
    wire [1023:0] shifted = in >> shift_amount;
    
    // Output is the lowest 4 bits after shifting
    assign out = shifted[3:0];

endmodule