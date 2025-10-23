module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Generate carry-out if the sum exceeds 9
    assign Cout = (bin_sum[4])? 1'b1 : 1'b0;

    // Apply correction if the sum exceeds 9
    wire [4:0] corrected_sum = (bin_sum > 9)? (bin_sum + 6) : bin_sum;

    // Assign the corrected sum to the output port
    assign Sum = corrected_sum[3:0];

endmodule