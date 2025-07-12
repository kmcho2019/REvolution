module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] bin_sum;
    wire       need_correction;

    // Binary sum of inputs with carry-in
    assign bin_sum = A + B + Cin;

    // Determine if correction is needed:
    // Correction is needed if bin_sum > 9
    // bin_sum > 9 means:
    // Either bin_sum[4] == 1 (sum >=16) or
    // bin_sum[3] & (bin_sum[2] | bin_sum[1]) == 1 (sum >=10)
    assign need_correction = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // If no correction needed, output is lower 4 bits of bin_sum
    // If correction needed, add 6 (0110)
    // Instead of adding 6 using a full adder, generate the corrected sum by logic:

    // Correction: corrected_sum = bin_sum + 6
    // 6 in binary: 0110

    wire c0, c1, c2; // internal carries for correction addition

    // bit0: sum bit0 xor correction bit0 (0)
    assign Sum[0] = bin_sum[0];

    // bit1: bin_sum[1] xor correction bit1 (1) xor carry_in (from bit0 addition)
    assign Sum[1] = bin_sum[1] ^ 1'b1;

    // bit2: bin_sum[2] xor correction bit2 (1) xor carry from bit1 addition
    // We generate carry internally to properly sum bits

    // Let's implement addition of bin_sum[3:0] + 0110 when correction is needed
    // Use carry ripple for bits 1 to 3

    wire bit1_sum, bit2_sum, bit3_sum;
    wire bit1_carry, bit2_carry, bit3_carry;

    // Start with bit1:
    // bit1_sum = bin_sum[1] ^ 1 (correction bit) ^ 0 (carry in)
    // carry out bit1 = (bin_sum[1] & 1) | (1 & 0) | (bin_sum[1] & 0) = bin_sum[1]
    assign bit1_sum = bin_sum[1] ^ 1'b1;
    assign bit1_carry = bin_sum[1] & 1'b1;

    // bit2:
    // bit2_sum = bin_sum[2] ^ 1 (correction bit) ^ bit1_carry
    assign bit2_sum = bin_sum[2] ^ 1'b1 ^ bit1_carry;
    assign bit2_carry = (bin_sum[2] & 1'b1) | (1'b1 & bit1_carry) | (bin_sum[2] & bit1_carry);

    // bit3:
    // bit3_sum = bin_sum[3] ^ 0 (correction bit) ^ bit2_carry
    assign bit3_sum = bin_sum[3] ^ bit2_carry;
    assign bit3_carry = (bin_sum[3] & bit2_carry);

    // bit0 stays same if correction needed
    // But if no correction needed, sum is bin_sum[3:0]

    // Generate final Sum bits with mux
    assign Sum[0] = need_correction ? bin_sum[0] : bin_sum[0];
    assign Sum[1] = need_correction ? bit1_sum    : bin_sum[1];
    assign Sum[2] = need_correction ? bit2_sum    : bin_sum[2];
    assign Sum[3] = need_correction ? bit3_sum    : bin_sum[3];

    // Carry out is either bin_sum[4] (if no correction) or carry out of corrected sum (bit3_carry)
    // If no correction needed, cout = bin_sum[4]
    // Else cout = bit3_carry (carry out from correction addition)
    assign Cout = need_correction ? bit3_carry : bin_sum[4];

endmodule