module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;          // 5-bit sum: includes carry out from 4-bit addition
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // Simplified condition:
    // raw_sum[4] == 1 means sum >= 16 > 9 (always correction needed)
    // Or if raw_sum[3] and (raw_sum[2] or raw_sum[1]) is set,
    // because 9 = 1001b, so sums from 10 to 15 meet this.
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 if correction needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output the corrected BCD sum and carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule