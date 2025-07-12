module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire correction_needed;
    wire [3:0] sum_nocorr;
    wire [3:0] sum_corr;
    wire c0, c1, c2;

    // Step 1: 5-bit addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction needed (raw_sum > 9)
    // Condition: bit4=1 OR (bit3=1 AND (bit2=1 OR bit1=1))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Prepare the uncorrected sum (lower nibble)
    assign sum_nocorr = raw_sum[3:0];

    // Step 3: Conditional addition of 6 (0110) to sum_nocorr when correction_needed is set
    // Bit0 of 6 is 0, so sum_corr[0] = sum_nocorr[0]
    assign {c0, sum_corr[0]} = {1'b0, sum_nocorr[0]}; // no addition needed, pass through

    // Bit1 of 6 is 1: sum_corr[1] = sum_nocorr[1] + correction_needed + carry_in(c0)
    assign {c1, sum_corr[1]} = sum_nocorr[1] + correction_needed + c0;

    // Bit2 of 6 is 1: sum_corr[2] = sum_nocorr[2] + correction_needed + carry_in(c1)
    assign {c2, sum_corr[2]} = sum_nocorr[2] + correction_needed + c1;

    // Bit3 of 6 is 0: sum_corr[3] = sum_nocorr[3] + 0 + carry_in(c2)
    assign sum_corr[3] = sum_nocorr[3] + c2;

    // Step 4: Choose corrected or uncorrected sum based on correction_needed
    assign Sum = correction_needed ? sum_corr : sum_nocorr;

    // Step 5: Carry out equals correction_needed
    assign Cout = correction_needed;

endmodule