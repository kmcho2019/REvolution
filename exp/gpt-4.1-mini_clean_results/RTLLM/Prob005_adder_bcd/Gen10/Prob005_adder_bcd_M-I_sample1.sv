module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // 5-bit raw sum of inputs and carry in
    assign raw_sum = A + B + Cin;

    // Correction needed if raw sum > 9
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Apply correction (add 6) only if needed, optimized without full adder for correction
    // corrected_sum = raw_sum + 6 if correction_needed else raw_sum
    // Add 6 = binary 0110, so add bits at positions 2 and 1 accordingly

    // Intermediate signals for corrected sum bits
    wire bit0 = raw_sum[0]; // bit0 never changes when adding 6 (which has LSB=0)
    
    // Bit1 correction: if correction needed, bit1 toggles according to raw_sum[1]
    // Adding 1 to bit1 and bit2; since 6 in binary is 0110, only bit1 and bit2 affected
    wire bit1 = correction_needed ? ~raw_sum[1] : raw_sum[1];
    
    // Bit2 correction depends on carry from bit1 addition
    wire carry_bit1 = correction_needed & raw_sum[1];
    wire bit2 = correction_needed ? (raw_sum[2] ^ carry_bit1) : raw_sum[2];

    // Bit3 correction depends on carry from bit2 addition
    wire carry_bit2 = correction_needed & (raw_sum[2] & carry_bit1);
    wire bit3 = raw_sum[3] ^ carry_bit2;

    assign Sum  = {bit3, bit2, bit1, bit0};
    assign Cout = correction_needed;

endmodule