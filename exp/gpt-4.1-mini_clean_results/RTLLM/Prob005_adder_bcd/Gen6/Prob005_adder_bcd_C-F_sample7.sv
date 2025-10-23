module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [3:0] sum_no_corr;
    wire [4:0] corrected_sum; // 4-bit sum + possible carry from adding 6

    // Step 1: 5-bit binary addition of inputs including carry-in
    assign binary_sum = A + B + Cin;

    // Step 2: Use optimized correction detection logic:
    // Correction needed if binary_sum > 9, equivalently:
    // binary_sum[4] == 1 OR (binary_sum[3] AND (binary_sum[2] OR binary_sum[1]))
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Step 3: Add correction value 6 (0110) only if correction is needed to the lower 4 bits
    assign sum_no_corr = binary_sum[3:0];
    assign corrected_sum = correction_needed ? (sum_no_corr + 4'd6) : {1'b0, sum_no_corr};

    // Step 4: Output corrected sum and carry-out
    // Cout is driven by correction_needed indicating sum > 9
    assign Sum = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule