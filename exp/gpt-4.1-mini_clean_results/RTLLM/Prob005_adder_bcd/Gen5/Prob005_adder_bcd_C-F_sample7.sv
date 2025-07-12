module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit sum with carry out

    // Correction needed if raw_sum > 9:
    // Using optimized logic: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [3:0] sum_low = raw_sum[3:0];

    // Add 6 (0110) to sum_low if correction_needed
    // Implement bitwise addition with carry chain for these 4 bits:

    // Bit 0 addition: sum_low[0] + 0 + 0
    wire sum0 = sum_low[0];
    wire carry0 = 1'b0;

    // Bit 1 addition: sum_low[1] + 1 + carry0
    wire bit1_addend = 1'b1;
    wire sum1 = sum_low[1] ^ bit1_addend ^ carry0;
    wire carry1 = (sum_low[1] & bit1_addend) | ((sum_low[1] ^ bit1_addend) & carry0);

    // Bit 2 addition: sum_low[2] + 1 + carry1
    wire bit2_addend = 1'b1;
    wire sum2 = sum_low[2] ^ bit2_addend ^ carry1;
    wire carry2 = (sum_low[2] & bit2_addend) | ((sum_low[2] ^ bit2_addend) & carry1);

    // Bit 3 addition: sum_low[3] + 0 + carry2
    wire bit3_addend = 1'b0;
    wire sum3 = sum_low[3] ^ bit3_addend ^ carry2;
    wire carry3 = (sum_low[3] & bit3_addend) | ((sum_low[3] ^ bit3_addend) & carry2);

    // Select between raw_sum lower bits and corrected sum bits based on correction_needed
    wire [3:0] corrected_sum = correction_needed ? {sum3, sum2, sum1, sum0} : sum_low;

    // Carry out is the OR of:
    // - the correction carry out when correction is needed
    // - the raw_sum[4] carry out when no correction is needed
    wire corrected_cout = correction_needed ? carry3 : 1'b0;
    wire Cout_comb = corrected_cout | (correction_needed ? 1'b0 : raw_sum[4]);

    assign Sum  = corrected_sum;
    assign Cout = Cout_comb;

endmodule