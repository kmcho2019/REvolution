module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // Step 1: Perform raw binary addition
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed
    // Correction needed if sum > 9 or carry_out (raw_sum[4]) is set
    // sum > 9 can be checked by (sum[3] & (sum[2] | sum[1])) or sum[4]
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Bitwise correction logic adding 6 (0110) if needed
    // Adding 6 to sum is equivalent to:
    // corrected_sum = raw_sum[3:0] + 6
    // But we implement this without a full adder for correction:
    // The +6 addition bits:
    // Bit 0: sum[0] ^ correction_needed (since 6 has bit0=0, but we only add 6 if needed)
    // Actually, +6 binary = 0110, so bits: b3=0, b2=1, b1=1, b0=0
    // We can implement correction by:
    // - Bit 0: unchanged (since 6 has 0 at bit 0)
    // - Bit 1: sum[1] XOR correction_needed (toggle bit 1 if correction)
    // - Bit 2: sum[2] XOR correction_needed
    // - Bit 3: sum[3] OR correction_needed (since adding 6 can produce carry out to bit 3)
    //
    // But to be precise, add 6 conditionally:
    // We'll implement a mini adder for bits 0-3 adding 6 only if correction is needed.

    wire c1, c2, c3; // carries inside correction adder
    wire [3:0] sum0 = raw_sum[3:0];

    // Bit 0: sum0[0] + 0 + 0 = sum0[0], no carry
    assign Sum[0] = sum0[0];

    // Bit 1: sum0[1] + 1 (correction_needed) + carry_in (0)
    assign Sum[1] = sum0[1] ^ correction_needed;
    assign c1     = sum0[1] & correction_needed;

    // Bit 2: sum0[2] + 1 (correction_needed) + c1
    assign Sum[2] = sum0[2] ^ correction_needed ^ c1;
    assign c2     = (sum0[2] & correction_needed) | (sum0[2] & c1) | (correction_needed & c1);

    // Bit 3: sum0[3] + 0 + c2
    assign Sum[3] = sum0[3] ^ c2;
    assign c3     = sum0[3] & c2;

    // Carry out is correction_needed OR carry generated from bit3 during correction
    assign Cout = correction_needed | c3;

endmodule