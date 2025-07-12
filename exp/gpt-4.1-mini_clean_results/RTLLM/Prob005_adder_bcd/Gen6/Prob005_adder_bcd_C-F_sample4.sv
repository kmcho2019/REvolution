module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9:
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [3:0] sum_nocorr = raw_sum[3:0];

    // Correction bits for adding 6 (0110), gated by correction_needed
    wire corr_bit1 = correction_needed; // bit1 of 6 is 1
    wire corr_bit2 = correction_needed; // bit2 of 6 is 1

    // Add correction bits conditionally to sum_nocorr using ripple carry

    // Bit 0 addition:
    // bit0 of 6 is 0, so no addition on bit0
    wire sum0 = sum_nocorr[0];
    wire c0 = 1'b0;

    // Bit 1 addition:
    // sum1 = s1 + corr_bit1 + c0
    wire sum1 = sum_nocorr[1] ^ corr_bit1 ^ c0;
    wire c1 = (sum_nocorr[1] & corr_bit1) | (sum_nocorr[1] & c0) | (corr_bit1 & c0);

    // Bit 2 addition:
    // sum2 = s2 + corr_bit2 + c1
    wire sum2 = sum_nocorr[2] ^ corr_bit2 ^ c1;
    wire c2 = (sum_nocorr[2] & corr_bit2) | (sum_nocorr[2] & c1) | (corr_bit2 & c1);

    // Bit 3 addition:
    // bit3 of 6 is 0, so sum3 = s3 + 0 + c2
    wire sum3 = sum_nocorr[3] ^ c2;
    wire c3 = sum_nocorr[3] & c2;

    // Select final Sum based on correction_needed:
    // If correction_needed == 1, output corrected sum; else output raw sum_nocorr
    assign Sum = correction_needed ? {sum3, sum2, sum1, sum0} : sum_nocorr;

    // Carry out is asserted if correction needed (sum > 9)
    assign Cout = correction_needed;

endmodule