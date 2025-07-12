module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout     // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction
    wire [4:0] corrected_sum;
    assign corrected_sum = (binary_sum > 9)? binary_sum + 6 : binary_sum;

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum[3:0];

    // Generate a carry-out (Cout) if the result exceeds 9
    assign Cout = (binary_sum > 9) || (corrected_sum[4] == 1);

endmodule