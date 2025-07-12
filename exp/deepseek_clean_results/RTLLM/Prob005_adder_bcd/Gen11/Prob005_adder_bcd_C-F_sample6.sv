module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial 5-bit sum including carry-in
    wire [4:0] binary_sum = A + B + Cin;
    
    // Optimized overflow detection (from Example 2):
    // True when either carry-out occurs or sum[3:0] > 9
    wire overflow = binary_sum[4] | 
                   (binary_sum[3] & (binary_sum[2] | binary_sum[1]));
    
    // Apply correction (from Example 1):
    // Add 6 when overflow occurs, using efficient bitwise selection
    wire [3:0] corrected_sum = binary_sum[3:0] + (overflow ? 4'd6 : 4'd0);
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = overflow | (binary_sum[3:0] > 4'd9);  // Redundant but ensures correctness

endmodule