module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform binary addition of inputs and carry-in
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed without using > operator
    // Correction is needed if:
    //  - raw_sum[4] is 1 (sum >= 16), or
    //  - raw_sum[3] and raw_sum[2] are both 1 (sum >= 12),
    //  - or raw_sum[3] and raw_sum[1] are both 1 (sum >= 10).
    // The condition covers all sums > 9.
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 if correction needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Assign the corrected lower 4 bits to Sum output
    assign Sum = corrected_sum[3:0];

    // Assign the MSB as Cout carry-out
    assign Cout = corrected_sum[4];

endmodule