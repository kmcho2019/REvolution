module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;           // 5-bit sum of A, B, and Cin
    wire       correction_needed;
    wire [3:0] sum_nocorr;
    wire [3:0] sum_corr;

    // Step 1: Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;
    assign sum_nocorr = raw_sum[3:0];

    // Step 2: Detect if correction is needed (sum > 9)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 (0110) to sum if correction needed using combinational logic
    // Adding 6 to the lower 4 bits with carry-in zero:
    // sum_corr = sum_nocorr + 6
    wire c0, c1, c2;
    assign {c0, sum_corr[0]} = sum_nocorr[0] + 1'b0;
    assign {c1, sum_corr[1]} = sum_nocorr[1] + 1'b1 + c0;  // Adding 1 on bit1 for '0110'
    assign {c2, sum_corr[2]} = sum_nocorr[2] + 1'b1 + c1;  // Adding 1 on bit2 for '0110'
    assign sum_corr[3] = sum_nocorr[3] + 1'b0 + c2;

    // Step 4: Output sum is corrected or not depending on correction_needed
    assign Sum  = correction_needed ? sum_corr : sum_nocorr;
    assign Cout = correction_needed;

endmodule