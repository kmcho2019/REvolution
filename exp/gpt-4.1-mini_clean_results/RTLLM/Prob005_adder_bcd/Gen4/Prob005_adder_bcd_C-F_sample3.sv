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

    // Perform binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction needed if raw_sum > 9, which can be detected by:
    // raw_sum[4] == 1 (sum > 15), or
    // raw_sum[3] == 1 and (raw_sum[2] == 1 or raw_sum[1] == 1) indicates sum > 9
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add correction (6) if needed to keep sum within BCD range
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output lower 4 bits as sum and MSB as carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule