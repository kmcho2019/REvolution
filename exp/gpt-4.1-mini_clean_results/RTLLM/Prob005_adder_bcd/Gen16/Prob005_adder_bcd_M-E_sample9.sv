module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;
    wire [4:0] correction_value;

    // Step 1: Perform 5-bit binary addition of A, B, and Cin
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed
    // Correction needed if raw_sum > 9
    // raw_sum > 9 if raw_sum[4] == 1 or (raw_sum[3:0] > 9)
    // Condition: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Define correction value: 6 (binary 00110) if correction needed, else 0
    assign correction_value = correction_needed ? 5'b00110 : 5'b00000;

    // Step 4: Add correction value to raw sum
    assign corrected_sum = raw_sum + correction_value;

    // Step 5: Output final BCD sum (4 LSBs) and carry-out (MSB)
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule