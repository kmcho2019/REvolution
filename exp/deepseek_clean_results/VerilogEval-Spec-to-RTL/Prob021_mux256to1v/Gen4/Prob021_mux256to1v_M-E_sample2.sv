module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the shift amount (sel * 4)
    wire [9:0] shift_amount = {sel, 2'b00};  // Multiply by 4
    
    // Barrel shifter implementation (right shift)
    wire [1023:0] shifted_in = in >> shift_amount;
    
    // Output is the least significant 4 bits after shifting
    assign out = shifted_in[3:0];
endmodule