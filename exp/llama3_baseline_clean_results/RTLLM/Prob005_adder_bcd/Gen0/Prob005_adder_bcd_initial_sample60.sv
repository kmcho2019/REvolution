module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output       Cout   // Carry-out output
);

    // Temporary sum before BCD correction
    wire [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // If the sum exceeds 9, apply BCD correction by adding 6 and set Cout
    assign Cout = (temp_sum > 9) ? 1'b1 : 1'b0;

    // Apply correction to ensure result is within BCD range
    assign Sum = (temp_sum > 9) ? temp_sum + 6 : temp_sum;

    // Since Sum is a 4-bit output, we should only consider the lower 4 bits
    // However, the correction and carry generation already account for this,
    // so the assignment remains straightforward.

endmodule