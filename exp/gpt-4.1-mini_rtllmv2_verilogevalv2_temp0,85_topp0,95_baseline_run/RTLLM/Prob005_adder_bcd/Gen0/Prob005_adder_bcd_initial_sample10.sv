module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Perform initial binary addition including carry in
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction needed if raw_sum > 9 or if carry out of the 4 LSBs (raw_sum[4]) is set
    assign correction_needed = (raw_sum > 5'd9);

    // If correction needed, add 6 to raw_sum to get corrected BCD sum
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output the lower 4 bits as the BCD sum
    assign Sum = corrected_sum[3:0];

    // The carry out is the 5th bit of corrected_sum
    assign Cout = corrected_sum[4];

endmodule