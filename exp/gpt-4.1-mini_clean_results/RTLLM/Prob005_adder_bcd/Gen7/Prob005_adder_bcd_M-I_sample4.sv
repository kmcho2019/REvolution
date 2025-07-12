module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // 5-bit binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // raw_sum[4] = bit 4
    // raw_sum[3], raw_sum[2], raw_sum[1] are bits 3,2,1 respectively
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (0110) if correction is needed, else add 0
    // Implement the addition of raw_sum[3:0] + (6 if correction_needed else 0) manually to reduce logic

    wire c1, c2, c3; // carry signals for correction adder

    // bit0: raw_sum[0] + 0 + 0 carry_in
    // bit1: raw_sum[1] + 1 + c1
    // bit2: raw_sum[2] + 1 + c2
    // bit3: raw_sum[3] + 0 + c3
    wire bit0_sum = raw_sum[0];
    assign c1 = bit0_sum & correction_needed; // since adding 0 + raw_sum[0], carry-in 0, no addition in bit0, carry to bit1 if raw_sum[0] and correction_needed

    wire bit1_sum = raw_sum[1] ^ correction_needed ^ 1'b0; // sum of bit1, add 1 if correction_needed
    wire bit1_carry = (raw_sum[1] & correction_needed) | (raw_sum[1] & 1'b0) | (correction_needed & 1'b0);

    wire bit2_sum = raw_sum[2] ^ correction_needed ^ bit1_carry;
    wire bit2_carry = (raw_sum[2] & correction_needed) | (raw_sum[2] & bit1_carry) | (correction_needed & bit1_carry);

    wire bit3_sum = raw_sum[3] ^ 1'b0 ^ bit2_carry;
    wire bit3_carry = (raw_sum[3] & 1'b0) | (raw_sum[3] & bit2_carry) | (1'b0 & bit2_carry);

    // To simplify the correction addition, it's easier to do a conditional addition using '+' with mux:
    wire [4:0] corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule