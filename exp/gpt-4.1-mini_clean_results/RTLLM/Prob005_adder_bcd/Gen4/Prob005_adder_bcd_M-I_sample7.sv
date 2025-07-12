module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [3:0] sum_without_correction;
    wire [3:0] corrected_sum;

    // Binary addition of A, B and Cin (5 bits for carry)
    assign binary_sum = A + B + Cin;

    // Partial decoding for correction condition:
    // Correction needed if binary_sum > 9
    // Which is equivalent to:
    // sum[4] == 1 (carry out from bit3 addition)
    // OR (sum[3] & (sum[2] | sum[1]))
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // If correction needed, add 6 (0110) to the lower 4 bits of binary_sum
    // Else, use lower 4 bits as is
    assign sum_without_correction = binary_sum[3:0];
    assign corrected_sum = correction_needed ? (sum_without_correction + 4'd6) : sum_without_correction;

    // Output sum and carry out
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule