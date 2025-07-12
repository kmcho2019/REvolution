module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform 5-bit addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction required if the 5-bit sum is greater than 9:
    // Condition for sum > 9 in BCD:
    // sum[4] == 1 OR (sum[3] AND (sum[2] OR sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (binary 0110) to raw_sum if correction needed to fix BCD sum
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule