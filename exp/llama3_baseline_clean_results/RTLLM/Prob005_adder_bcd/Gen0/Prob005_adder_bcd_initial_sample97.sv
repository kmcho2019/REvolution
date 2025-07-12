module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout  // Carry-out output
);

    // Temporary sum of A, B, and Cin
    wire [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 (1001 in binary)
    assign Cout = (temp_sum > 9) ? 1'b1 : 1'b0;

    // Apply correction if sum exceeds 9
    assign Sum = (temp_sum > 9) ? (temp_sum + 6)[3:0] : temp_sum[3:0];

endmodule