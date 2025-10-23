module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit sum to hold carry-out

    // Correction needed if raw_sum > 9.
    // Instead of magnitude comparator, use boolean logic:
    // raw_sum > 9 when (raw_sum[4] == 1) OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    // Explanation: For numbers above 9 (binary 01010 to 11111),
    // bit 4 (MSB) = 1 means > 15; or if bit4=0 and bits 3 and either bit2 or bit1 set => >9
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (0110) if correction needed; otherwise pass raw_sum
    // Implement addition of 6 by bitwise logic for area and power optimization

    // Break down raw_sum lower 4 bits for correction addition
    wire [3:0] sum_low = raw_sum[3:0];

    // Correction addition: sum_low + 6 (0110) = sum_low + 4'b0110
    // Use simple adder logic for 4 bits plus carry_in=0

    wire c0 = correction_needed; // initial carry-in for adding 6 if correction needed
    wire s0 = sum_low[0] ^ (correction_needed & 1'b0) ^ 1'b0; // bit0 + 0 + 0 => bit0 unchanged (6 LSB=0)
    wire c1 = (sum_low[0] & (correction_needed & 1'b0)) | ((sum_low[0] ^ (correction_needed & 1'b0)) & 1'b0); // always 0

    // But since 6 = 0110 binary, bits: b0=0, b1=1, b2=1, b3=0
    // Let's implement the addition with carry properly:

    // Add bit 0:
    // sum_low[0] + 0 + 0 = sum_low[0], carry out = 0
    wire carry0 = 0;
    wire sum0 = sum_low[0];

    // Add bit 1:
    // sum_low[1] + 1 + carry0
    wire sum1 = sum_low[1] ^ 1'b1 ^ carry0;
    wire carry1 = (sum_low[1] & 1'b1) | ( (sum_low[1] ^ 1'b1) & carry0);

    // Add bit 2:
    // sum_low[2] + 1 + carry1
    wire sum2 = sum_low[2] ^ 1'b1 ^ carry1;
    wire carry2 = (sum_low[2] & 1'b1) | ( (sum_low[2] ^ 1'b1) & carry1);

    // Add bit 3:
    // sum_low[3] + 0 + carry2
    wire sum3 = sum_low[3] ^ 1'b0 ^ carry2;
    wire carry3 = (sum_low[3] & 1'b0) | ( (sum_low[3] ^ 1'b0) & carry2);

    // Now build corrected_sum:
    wire [4:0] corrected_sum;
    assign corrected_sum[0] = correction_needed ? sum0 : sum_low[0];
    assign corrected_sum[1] = correction_needed ? sum1 : sum_low[1];
    assign corrected_sum[2] = correction_needed ? sum2 : sum_low[2];
    assign corrected_sum[3] = correction_needed ? sum3 : sum_low[3];
    assign corrected_sum[4] = correction_needed ? carry3 | raw_sum[4] : raw_sum[4];

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule