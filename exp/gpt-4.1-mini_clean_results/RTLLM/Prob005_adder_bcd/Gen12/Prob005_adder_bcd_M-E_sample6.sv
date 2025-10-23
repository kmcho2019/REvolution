module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Perform binary addition with carry-in, 5-bit width
    wire [4:0] raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed:
    // Correction needed if raw_sum > 9
    // Using simpler condition based on BCD invalid patterns:
    // (raw_sum[3] & (raw_sum[2] | raw_sum[1])) | raw_sum[4]
    wire correction_needed = (raw_sum[3] & (raw_sum[2] | raw_sum[1])) | raw_sum[4];

    // Step 3: Define correction value (6 decimal) to add when needed
    wire [3:0] correction = correction_needed ? 4'b0110 : 4'b0000;

    // Step 4: Add correction to lower 4 bits of raw_sum
    wire [4:0] corrected_sum_with_carry;
    wire carry_correction;

    // 4-bit adder for correction with carry_in = 0
    assign {carry_correction, corrected_sum_with_carry[3:0]} = raw_sum[3:0] + correction;

    // carry_out is set if raw_sum had carry out or correction adder has carry out
    assign Cout = raw_sum[4] | carry_correction;

    // Final Sum is corrected_sum_with_carry lower 4 bits
    assign Sum = corrected_sum_with_carry[3:0];

endmodule