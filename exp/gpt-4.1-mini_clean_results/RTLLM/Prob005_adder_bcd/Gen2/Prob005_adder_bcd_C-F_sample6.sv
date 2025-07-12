module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // 4-bit binary addition plus carry-in produces a 5-bit result
    assign binary_sum = A + B + Cin;

    // Efficient correction condition:
    // correction is needed if sum > 9, which can be checked as:
    // either binary_sum[4] is set (overflow),
    // or binary_sum[3] AND (binary_sum[2] OR binary_sum[1]) is set
    // This condition detects sums from 10 to 15
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Add 6 (0110) if correction is needed, else keep sum unchanged
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Output the corrected 4-bit sum and the carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule