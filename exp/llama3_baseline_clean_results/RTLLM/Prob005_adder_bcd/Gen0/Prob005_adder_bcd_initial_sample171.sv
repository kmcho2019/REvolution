module adder_bcd(
    input [3:0] A,  // First BCD input (4-bit)
    input [3:0] B,  // Second BCD input (4-bit)
    input Cin,      // Carry-in input (1-bit)
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout      // Carry-out output (1-bit)
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] temp_sum;  // Temporary sum (5-bit) to handle carry
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    assign Sum = (temp_sum > 9)? (temp_sum + 6) : temp_sum;
    assign Cout = (temp_sum > 9)? 1'b1 : (temp_sum[4] == 1'b1)? 1'b1 : 1'b0;

    // Assign the lower 4 bits of the corrected sum to the output Sum
    // The Cout is 1 if the sum exceeds 9 or if there's a carry from the binary addition
    assign Sum = (temp_sum > 9)? (temp_sum + 6)[3:0] : temp_sum[3:0];

endmodule