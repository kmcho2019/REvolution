module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;      // 5-bit to capture carry out of 4-bit addition
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Perform binary addition of A, B, and Cin
    assign bin_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction needed if bin_sum > 9 (decimal 9 is binary 1001)
    assign correction_needed = (bin_sum > 5'd9);

    // Add 6 (0110) if correction needed
    assign corrected_sum = correction_needed ? (bin_sum + 5'd6) : bin_sum;

    // The corrected_sum[3:0] is the final BCD sum digit
    assign Sum = corrected_sum[3:0];

    // Carry out if correction was needed, or if there was carry from 4-bit addition
    assign Cout = corrected_sum[4];

endmodule