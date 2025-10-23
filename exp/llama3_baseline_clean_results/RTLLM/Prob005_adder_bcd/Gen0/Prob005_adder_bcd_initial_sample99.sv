module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output Cout    // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 and apply correction
    wire [3:0] corrected_sum;
    assign corrected_sum = (bin_sum[4] ? bin_sum[3:0] + 4'd6 : bin_sum[3:0]);

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

    // Generate carry-out if the result exceeds 9
    assign Cout = bin_sum[4] | (corrected_sum > 4'd9);

endmodule