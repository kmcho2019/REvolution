module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;          // 5-bit sum to hold carry out
    wire       correction_needed;
    wire [4:0] corrected_sum_plus6;

    // Step 1: Perform 5-bit addition of A, B, and Cin
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Detect if correction needed (sum > 9)
    // Correction needed if raw_sum[4] == 1 or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: If correction needed, add 6 (0110) to raw_sum[3:0]
    assign corrected_sum_plus6 = {1'b0, raw_sum[3:0]} + 5'd6;

    // Step 4: Select final sum: 
    // If correction needed, use corrected_sum_plus6[3:0], else raw_sum[3:0]
    assign Sum = correction_needed ? corrected_sum_plus6[3:0] : raw_sum[3:0];

    // Step 5: Carry-out generated if correction is needed
    assign Cout = correction_needed;

endmodule