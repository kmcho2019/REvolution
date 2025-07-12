module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction if necessary
    assign Sum = (binary_sum > 9)? (binary_sum + 6) : binary_sum;
    assign Cout = (binary_sum > 9) || ((binary_sum + 6) > 9)? 1'b1 : 1'b0;

    // Ensure Sum is only 4 bits by taking the lower 4 bits of the result
    assign Sum = Sum[3:0];

endmodule