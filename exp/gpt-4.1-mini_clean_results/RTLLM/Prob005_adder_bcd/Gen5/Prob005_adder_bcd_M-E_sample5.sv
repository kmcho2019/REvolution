module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire c1, c2, c3, c4;
    wire [3:0] raw_sum;

    // 4-bit ripple carry adder for A + B + Cin
    // Bit 0
    assign raw_sum[0] = A[0] ^ B[0] ^ Cin;
    assign c1 = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);

    // Bit 1
    assign raw_sum[1] = A[1] ^ B[1] ^ c1;
    assign c2 = (A[1] & B[1]) | (A[1] & c1) | (B[1] & c1);

    // Bit 2
    assign raw_sum[2] = A[2] ^ B[2] ^ c2;
    assign c3 = (A[2] & B[2]) | (A[2] & c2) | (B[2] & c2);

    // Bit 3
    assign raw_sum[3] = A[3] ^ B[3] ^ c3;
    assign c4 = (A[3] & B[3]) | (A[3] & c3) | (B[3] & c3);

    // Correction needed if raw_sum > 9 or carry out from addition c4 = 1
    // Condition: correction_needed = c4 | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed;
    assign correction_needed = c4 | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // BCD correction: add 6 to raw_sum if correction_needed.
    // Since adding 6 is adding binary '0110', we can compute corrected bits as:
    // corrected_sum[0] = raw_sum[0] (LSB not affected by correction)
    // corrected_sum[1] = raw_sum[1] ^ correction_needed
    // corrected_sum[2] = raw_sum[2] ^ correction_needed
    // corrected_sum[3] = raw_sum[3] & ~correction_needed | (~raw_sum[3] & correction_needed & raw_sum[2])
    // The carry out Cout equals correction_needed (indicates a carry for the BCD digit)

    wire [3:0] corrected_sum;

    assign corrected_sum[0] = raw_sum[0];
    assign corrected_sum[1] = raw_sum[1] ^ correction_needed;
    assign corrected_sum[2] = raw_sum[2] ^ correction_needed;
    assign corrected_sum[3] = raw_sum[3] & ~correction_needed | (~raw_sum[3] & correction_needed & raw_sum[2]);

    assign Sum  = corrected_sum;
    assign Cout = correction_needed;

endmodule