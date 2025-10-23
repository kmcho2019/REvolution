module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] sum_raw;
    wire       correction_needed;
    wire [4:0] sum_corrected;

    // 5-bit raw sum of inputs including carry-in
    assign sum_raw = A + B + Cin;

    // Determine if correction is needed:
    // Correction needed if sum_raw > 9 (1001 binary)
    // Condition: sum_raw[4] == 1 (sum >= 16) OR
    //            (sum_raw[3] == 1 AND (sum_raw[2] == 1 OR sum_raw[1] == 1))
    // Explanation: BCD invalid if sum > 9 = 4'b1001
    assign correction_needed = sum_raw[4] | (sum_raw[3] & (sum_raw[2] | sum_raw[1]));

    // Add 6 (4'b0110) if correction needed
    assign sum_corrected = correction_needed ? (sum_raw + 5'd6) : sum_raw;

    // Output corrected sum and carry out
    assign Sum  = sum_corrected[3:0];
    assign Cout = sum_corrected[4];

endmodule