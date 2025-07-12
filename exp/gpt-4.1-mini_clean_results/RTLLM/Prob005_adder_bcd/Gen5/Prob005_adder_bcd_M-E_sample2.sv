module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] correction_value;
    wire [5:0] corrected_sum; // 5-bit sum + 1-bit carry

    // Step 1: Perform binary addition of A, B, and Cin (5-bit to capture carry)
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction needed:
    // Condition for invalid BCD: raw_sum > 9 (decimal), which is 01001 binary
    // Using bitwise logic: correction_needed = raw_sum > 9
    // Condition: correction_needed if carry out of raw_sum[4] is 1 or
    // (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = (raw_sum > 5'd9);

    // Step 3: Set correction value as 6 (0110) if correction_needed else 0
    assign correction_value = correction_needed ? 5'd6 : 5'd0;

    // Step 4: Add correction to raw_sum to get the final BCD sum
    assign corrected_sum = raw_sum + correction_value;

    // Step 5: Assign final outputs
    assign Sum = corrected_sum[3:0];         // Lower 4 bits are the BCD sum digit
    assign Cout = corrected_sum[4];          // The 5th bit is the BCD carry-out

endmodule