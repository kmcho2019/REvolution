module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output for the sum
    output Cout       // Carry-out output
);

    // Temporary variable to hold the initial sum before BCD correction
    wire [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction
    assign Sum = (temp_sum > 9) ? (temp_sum + 6) : temp_sum;

    // Adjust Sum to be 4 bits by taking the lower 4 bits of the result
    assign Sum = Sum[3:0];

    // Generate carry-out if the result exceeds 9
    assign Cout = (temp_sum > 9) ? 1'b1 : (temp_sum[4] == 1'b1);

endmodule