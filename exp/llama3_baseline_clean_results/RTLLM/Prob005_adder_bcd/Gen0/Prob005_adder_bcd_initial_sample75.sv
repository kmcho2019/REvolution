module adder_bcd(
    A,      // First BCD input (4-bit)
    B,      // Second BCD input (4-bit)
    Cin,    // Carry-in input (1-bit)
    Sum,    // 4-bit output representing the sum of the two BCD inputs
    Cout    // Carry-out output (1-bit)
);

    input [3:0] A;  // 4-bit input representing a decimal digit from 0 to 9
    input [3:0] B;  // 4-bit input representing a decimal digit from 0 to 9
    input Cin;     // 1-bit carry-in input
    output [3:0] Sum;  // 4-bit output representing the sum of the two BCD inputs
    output Cout;     // 1-bit carry-out output

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply the BCD correction if necessary
    assign Sum = (binary_sum > 9) ? (binary_sum + 6)[3:0] : binary_sum[3:0];

    // Generate a carry-out if the result exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

endmodule