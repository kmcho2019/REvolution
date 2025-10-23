module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (binary 1001)
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

    // If the binary sum exceeds 9, add 6 (binary 0110) for BCD correction
    wire [4:0] corrected_sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Assign the corrected sum (lower 4 bits) to the output Sum
    assign Sum = corrected_sum[3:0];

endmodule