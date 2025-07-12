module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout  // Carry-out output
);

    // Internal wire for the binary sum
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9
    assign Sum = (binary_sum > 9) ? (binary_sum + 6) : binary_sum;

    // Generate carry-out if the result exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : ((binary_sum + 6) > 9) ? 1'b1 : 1'b0;

    // Alternative way to generate carry-out
    // assign Cout = (Sum > 9) ? 1'b1 : 1'b0;

endmodule