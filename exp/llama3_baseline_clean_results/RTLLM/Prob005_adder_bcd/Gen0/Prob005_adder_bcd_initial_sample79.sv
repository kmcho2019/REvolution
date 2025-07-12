module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output Cout     // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and generate the carry-out
    assign Cout = (binary_sum > 9) ? 1'b1 : 1'b0;

    // If the sum exceeds 9, add 6 to correct it and ensure it's within the BCD range
    assign Sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Ensure Sum is 4-bit by taking the lower 4 bits
    assign Sum = Sum[3:0];

endmodule