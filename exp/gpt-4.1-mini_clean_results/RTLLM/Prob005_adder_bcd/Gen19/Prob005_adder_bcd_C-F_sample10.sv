module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: 5-bit binary addition of inputs and carry-in
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Detect correction need using optimized boolean logic:
    // overflow if sum > 9, i.e., if MSB set or bits 3 and (2 or 1) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add BCD correction (6 = 0110) when needed using bit-level addition

    // Extract lower nibble of raw_sum for correction addition
    wire [3:0] sum_low = raw_sum[3:0];

    // Add 6 to sum_low if correction_needed = 1; else sum_low unchanged.
    // Implement sum_low + (correction_needed ? 4'b0110 : 4'b0000)

    // bit 0:
    wire sum0 = sum_low[0]; // 0 + bit0 + 0 carry = bit0 unchanged
    wire carry0 = 1'b0;     // no carry from bit0 addition since correction bit0=0

    // bit 1:
    wire c1_in = carry0;
    wire corr_bit1 = correction_needed & 1'b1;
    wire sum1 = sum_low[1] ^ corr_bit1 ^ c1_in;
    wire carry1 = (sum_low[1] & corr_bit1) | ( (sum_low[1] ^ corr_bit1) & c1_in);

    // bit 2:
    wire c2_in = carry1;
    wire corr_bit2 = correction_needed & 1'b1;
    wire sum2 = sum_low[2] ^ corr_bit2 ^ c2_in;
    wire carry2 = (sum_low[2] & corr_bit2) | ( (sum_low[2] ^ corr_bit2) & c2_in);

    // bit 3:
    wire c3_in = carry2;
    wire corr_bit3 = correction_needed & 1'b0; // correction bit3 = 0
    wire sum3 = sum_low[3] ^ corr_bit3 ^ c3_in;
    wire carry3 = (sum_low[3] & corr_bit3) | ( (sum_low[3] ^ corr_bit3) & c3_in);

    // Step 4: Assemble corrected sum bits, choose between corrected and raw sum_low bits
    wire [3:0] corrected_sum_low = {
        sum3,
        sum2,
        sum1,
        sum0
    };
    // Combine carry from correction addition with raw_sum[4]
    wire corrected_carry_out = correction_needed ? carry3 | raw_sum[4] : raw_sum[4];

    assign Sum  = correction_needed ? corrected_sum_low : sum_low;
    assign Cout = corrected_carry_out;

endmodule