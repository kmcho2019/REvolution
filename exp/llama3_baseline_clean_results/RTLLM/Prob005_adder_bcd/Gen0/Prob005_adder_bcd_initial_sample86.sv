module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of A and B
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9
    wire [4:0] temp_sum;
    assign temp_sum = (bin_sum > 9)? bin_sum + 6 : bin_sum;

    // Generate carry-out if the result exceeds 9
    assign Cout = (temp_sum > 9)? 1'b1 : 1'b0;

    // Ensure the final sum is within the BCD range (0-9)
    assign Sum = temp_sum[3:0];

endmodule