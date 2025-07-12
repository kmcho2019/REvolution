module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction
    wire [3:0] corrected_sum;
    assign corrected_sum = (bin_sum > 9)? bin_sum + 6 : bin_sum[3:0];

    // Generate carry-out (Cout) if the final sum exceeds 9
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

endmodule