module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;          // 5-bit sum including carry
    wire       correction_needed;

    // Step 1: Add inputs A, B and Cin as a 5-bit number
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    // Condition: carry out OR (sum[3] AND (sum[2] OR sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Apply BCD correction by adding 6 (0110) if needed
    // Implement addition of 6 with minimal logic using combinational gates:

    // Break down raw_sum bits for clarity
    wire s0 = raw_sum[0];
    wire s1 = raw_sum[1];
    wire s2 = raw_sum[2];
    wire s3 = raw_sum[3];

    // Adding 6 (0110) means:
    // bit 0: sum_bit0 + 0 + carry_in0
    // bit 1: sum_bit1 + 1 + carry_in1
    // bit 2: sum_bit2 + 1 + carry_in2
    // bit 3: sum_bit3 + 0 + carry_in3

    // Because 6 = 0110 binary, add only bits 1 and 2 with 1

    // Use carry chain for correction addition
    wire c1, c2, c3;

    // sum bit 0 after correction (no addition here)
    wire sum0 = s0;

    // bit 1 sum and carry
    wire sum1 = s1 ^ correction_needed;
    assign c1 = s1 & correction_needed;

    // bit 2 sum and carry
    wire sum2 = s2 ^ correction_needed ^ c1;
    assign c2 = (s2 & correction_needed) | (c1 & (s2 ^ correction_needed));

    // bit 3 sum and carry
    wire sum3 = s3 ^ c2;
    assign c3 = s3 & c2;

    // Cout is correction_needed or carry out of this correction addition
    assign Cout = correction_needed | c3;

    // Output corrected sum
    assign Sum = {sum3, sum2, sum1, sum0};

endmodule