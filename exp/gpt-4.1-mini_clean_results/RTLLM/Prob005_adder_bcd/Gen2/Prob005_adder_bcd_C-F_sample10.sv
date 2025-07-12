module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;         // 5-bit sum to hold carry out
    wire       correction_needed;
    wire [3:0] corrected_sum;
    wire       carry_from_correction;

    // Step 1: Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed using logical expression:
    // correction_needed = raw_sum > 9
    // A known optimized logic for raw_sum > 9:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 (0110) if correction is needed
    // Implement the +6 addition with minimal logic
    // sum after correction = raw_sum[3:0] + (correction_needed ? 6 : 0)
    // Implement a small adder for this correction
    wire [4:0] corrected_sum_w;
    assign corrected_sum_w = {1'b0, raw_sum[3:0]} + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = corrected_sum_w[3:0];
    assign Cout = correction_needed; // carry out is simply if correction was needed

endmodule