module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;       // 5-bit sum of A+B+Cin
    wire       correction_needed;
    wire [3:0] sum_after_correction;
    wire       carry_correction;

    // Step 1: Binary addition of inputs
    assign raw_sum = A + B + Cin;

    // Step 2: Determine if correction is needed:
    // Condition for BCD correction (sum > 9) can be deduced as:
    // correction_needed = (raw_sum[4]) OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    // Explanation:
    // raw_sum[4]: sum >= 16 -> definitely > 9
    // raw_sum[3] & (raw_sum[2] | raw_sum[1]): sum >= 10 (binary 1010)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction value 6 (0110) if needed
    // Perform a conditional addition of 6 to the lower 4 bits of raw_sum.
    // Use correction_needed as carry_in for the adder that adds 6.
    wire [4:0] correction_adder_out;
    wire [3:0] to_add = 4'b0110;

    // 4-bit adder: sum of lower 4 bits + 6 if correction_needed
    assign correction_adder_out = {1'b0, raw_sum[3:0]} + (correction_needed ? {1'b0, to_add} : 5'b0);

    // Sum output is the lower 4 bits of the corrected sum
    assign Sum = correction_needed ? correction_adder_out[3:0] : raw_sum[3:0];

    // Carry out is 1 if correction was applied or if raw_sum had the 5th bit set
    assign Cout = correction_needed;

endmodule