module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;

    // Perform 4-bit addition with carry-in, producing 5-bit raw sum
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if correction needed based on BCD rules:
    // Correction is needed if:
    //  - raw_sum has a carry out (bit 4 == 1)
    //  - OR raw_sum[3] == 1 and (raw_sum[2] == 1 or raw_sum[1] == 1)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [4:0] corrected_sum;
    wire       corr_carry;

    // Add 6 (0110) to raw_sum[3:0] if correction is needed
    // This is a 4-bit addition with carry-in = 0
    assign {corr_carry, corrected_sum[3:0]} = raw_sum[3:0] + (correction_needed ? 4'b0110 : 4'b0000);
    assign corrected_sum[4] = 1'b0; // no bit 4 after correction addition

    // Final Sum and Cout
    // Cout is carry from correction addition or original raw_sum carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed ? corr_carry : raw_sum[4];

endmodule