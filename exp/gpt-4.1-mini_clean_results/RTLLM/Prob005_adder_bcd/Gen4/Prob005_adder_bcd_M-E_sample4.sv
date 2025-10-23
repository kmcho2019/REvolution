module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;
    wire       sum_invalid;
    wire [3:0] corrected_sum;
    wire       correction_needed;

    // Step 1: binary addition of inputs plus carry-in
    assign bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if raw sum is invalid BCD digit:
    // BCD digits 0 to 9 valid, so if sum > 9 -> correction needed
    // Condition: sum_invalid if carry-out from addition (bin_sum[4]) is 1
    // or if sum[3] & (sum[2] | sum[1]) is true (sum > 9)
    assign sum_invalid = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Step 3: Add 6 (0110) when correction needed, else pass through raw sum[3:0]
    // Implement addition of sum[3:0] + 6 if sum_invalid, else sum[3:0]
    wire [3:0] sum_lower = bin_sum[3:0];
    wire [3:0] six = 4'b0110;

    wire c1, c2, c3;

    // Bit 0 addition
    wire s0 = sum_lower[0] ^ six[0];
    wire c0 = sum_lower[0] & six[0];

    // Bit 1 addition
    wire s1 = sum_lower[1] ^ six[1] ^ c0;
    assign c1 = (sum_lower[1] & six[1]) | (six[1] & c0) | (sum_lower[1] & c0);

    // Bit 2 addition
    wire s2 = sum_lower[2] ^ six[2] ^ c1;
    assign c2 = (sum_lower[2] & six[2]) | (six[2] & c1) | (sum_lower[2] & c1);

    // Bit 3 addition
    wire s3 = sum_lower[3] ^ six[3] ^ c2;
    assign c3 = (sum_lower[3] & six[3]) | (six[3] & c2) | (sum_lower[3] & c2);

    // Select between raw sum or corrected sum based on sum_invalid
    assign corrected_sum = sum_invalid ? {s3, s2, s1, s0} : sum_lower;

    // Cout is sum_invalid (correction done indicates carry to next digit)
    assign Cout = sum_invalid;

    // Final sum output
    assign Sum = corrected_sum;

endmodule