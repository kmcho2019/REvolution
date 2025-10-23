module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Binary addition of A, B, Cin producing 5-bit sum (raw_sum)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Detect if correction needed (sum > 9)
    // Correction needed if raw_sum > 9, optimized logic:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Implement +6 correction efficiently without a full adder:
    // Adding 6 (0110) when correction_needed is high.

    // raw_sum lower nibble
    wire s3 = raw_sum[3];
    wire s2 = raw_sum[2];
    wire s1 = raw_sum[1];
    wire s0 = raw_sum[0];

    // Correction bits (6) = 0110
    // We'll add this to s3..s0 conditionally.

    // Implement addition s + (correction_needed ? 6 : 0)
    // Bit 0:
    // sum0 = s0 XOR 0 XOR 0 = s0 (since bit0 of 6 is 0)
    wire sum0 = s0;

    // Bit 1:
    // sum1 = s1 XOR (correction_needed & 1) XOR carry_in
    // bit1 of 6 = 1
    wire c0 = 0; // carry in to bit1 addition from bit0 addition is always 0 as bit0 correction bit = 0
    wire sum1 = s1 ^ correction_needed;
    wire c1 = s1 & correction_needed; // carry from bit1 addition

    // Bit 2:
    // bit2 of 6 = 1
    // sum2 = s2 XOR correction_needed XOR carry from previous
    wire sum2 = s2 ^ correction_needed ^ c1;
    wire c2 = (s2 & correction_needed) | (s2 & c1) | (correction_needed & c1);

    // Bit 3:
    // bit3 of 6 = 0
    // sum3 = s3 XOR 0 XOR carry from previous = s3 XOR c2
    wire sum3 = s3 ^ c2;
    wire c3 = s3 & c2; // carry out from MSB addition

    // Step 4: Assign output Sum and Cout
    assign Sum  = {sum3, sum2, sum1, sum0};
    // Cout is carry out of correction addition if correction was needed,
    // otherwise carry out is raw_sum[4].
    // Since correction_needed implies raw_sum > 9 and thus carry out.
    // We pick correction_needed as Cout because adding 6 when needed always causes carry out.
    assign Cout = correction_needed;

endmodule