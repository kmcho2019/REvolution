module adder_bcd(
    input [3:0] A,  // First BCD input (4-bit)
    input [3:0] B,  // Second BCD input (4-bit)
    input Cin,     // Carry-in input (1-bit)
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout     // Carry-out output (1-bit)
);

    // Intermediate signal to hold the binary sum
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (binary 1001)
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

    // Apply BCD correction if the sum exceeds 9
    assign Sum = (binary_sum > 9) ? (binary_sum + 6) : binary_sum;

    // Since Sum is a 4-bit output, ensure it doesn't exceed 4 bits
    // This is implicitly handled by the assign statement above, as it only assigns the lower 4 bits.

endmodule