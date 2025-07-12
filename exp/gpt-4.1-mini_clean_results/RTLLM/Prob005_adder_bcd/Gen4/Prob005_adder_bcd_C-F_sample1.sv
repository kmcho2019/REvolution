module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire correction_needed;

    // Step 1: Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    // Condition: raw_sum > 9 == raw_sum[4] or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditional addition of 6 (0110) to lower nibble if correction needed
    // Add 6 only when correction_needed is asserted, otherwise add 0
    wire c0, c1, c2;
    wire [3:0] sum_nocorr = raw_sum[3:0];
    wire [3:0] sum_corr;

    // Add (correction_needed ? 6 : 0) to sum_nocorr
    // Bitwise addition with carry chain
    assign {c0, sum_corr[0]} = sum_nocorr[0] + 1'b0;
    assign {c1, sum_corr[1]} = sum_nocorr[1] + correction_needed + c0;  // bit 1 of 6 is 1
    assign {c2, sum_corr[2]} = sum_nocorr[2] + correction_needed + c1;  // bit 2 of 6 is 1
    assign sum_corr[3] = sum_nocorr[3] + 1'b0 + c2;                    // bit 3 of 6 is 0

    // Step 4: Choose corrected or uncorrected sum
    assign Sum  = correction_needed ? sum_corr : sum_nocorr;

    // Step 5: Carry out is correction_needed OR carry from correction addition's MSB if correction applied
    // Since correction_needed means sum > 9, Cout = correction_needed is sufficient and correct
    assign Cout = correction_needed;

endmodule