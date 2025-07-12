module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Perform 5-bit binary addition to capture carry out
    wire [4:0] raw_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9)
    // Correction needed if raw_sum[4] == 1 or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (0110) for correction if needed
    wire [4:0] corrected_sum = correction_needed ? ({1'b0, raw_sum[3:0]} + 5'd6) : raw_sum;

    // Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule