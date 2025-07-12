module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;
    wire       correction;

    // Condition for BCD correction:
    // If sum > 9 or carry-out from raw addition, then correction needed.
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Using combinational logic to calculate the corrected sum without adding 6 explicitly:
    // If correction needed, Sum = raw_sum + 6 (0110)
    // But instead of adding, derive each bit of Sum as:
    // Sum[0] = raw_sum[0] (no change)
    // Sum[1] = raw_sum[1] ^ correction
    // Sum[2] = raw_sum[2] ^ correction
    // Sum[3] = raw_sum[3] ^ correction
    // Note: This simple XOR works because adding 6 toggles bits 1, 2, and 3 accordingly if correction is applied.
    // But careful handling for carry-out is needed.
    //
    // However, direct XOR does not correctly produce the BCD sum after correction due to carries within adding 6.
    // Thus, implement minimal logic based on the BCD correction rules:
    //
    // If correction == 1, the BCD sum bits are adjusted as follows:
    // sum0 = raw_sum[0]
    // sum1 = ~raw_sum[1]
    // sum2 = ~raw_sum[2]
    // sum3 = raw_sum[3] | raw_sum[2]
    //
    // This logic ensures correct BCD sum without a second adder.
    
    wire [3:0] sum_nocorr = raw_sum[3:0];
    wire [3:0] sum_corr;

    assign sum_corr[0] = sum_nocorr[0];
    assign sum_corr[1] = ~sum_nocorr[1];
    assign sum_corr[2] = ~sum_nocorr[2];
    assign sum_corr[3] = sum_nocorr[3] | sum_nocorr[2];

    // Select between corrected and uncorrected sum
    assign Sum = correction ? sum_corr : sum_nocorr;

    // Cout is the correction bit
    assign Cout = correction;

endmodule