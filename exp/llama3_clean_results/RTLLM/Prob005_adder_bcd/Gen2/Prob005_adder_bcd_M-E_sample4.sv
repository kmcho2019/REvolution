module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Correct the sum if it exceeds 9
    wire [3:0] corrected_sum;
    assign corrected_sum = (bin_sum[3] || (bin_sum[3:0] == 4'b1000))? bin_sum[3:0] + 4'b0110 : bin_sum[3:0];

    // Generate carry-out
    assign Cout = (bin_sum[4] == 1'b1) || ((bin_sum[3:0] + 4'b0110) > 9);

    // Assign the corrected sum to the output port
    assign Sum = corrected_sum;

endmodule