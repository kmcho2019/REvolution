module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // 1. Raw addition of A, B, and Cin (5 bits to catch carry out)
    assign raw_sum = A + B + Cin;

    // 2. Correction needed if raw_sum > 9 (1001)
    // Equivalent to: raw_sum[4] == 1 OR raw_sum[3:0] > 9
    // Since raw_sum[4] = carry out from 4-bit addition, we check that or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // 3. Correction addition: add 6 (0110) when correction_needed=1
    // Instead of a full adder, use bitwise logic for correction addition with carry ripple
    wire c0, c1, c2, c3; // carry signals inside correction adder
    
    // Add raw_sum[0] + 0 + 0 (LSB of correction 6 = 0)
    assign Sum[0] = raw_sum[0]; // no change since adding 0

    // Bit 1: raw_sum[1] + correction bit 1 (1) + carry_in (0)
    assign Sum[1] = raw_sum[1] ^ correction_needed;
    assign c0 = raw_sum[1] & correction_needed;

    // Bit 2: raw_sum[2] + correction bit 2 (1) + c0
    assign Sum[2] = raw_sum[2] ^ correction_needed ^ c0;
    assign c1 = (raw_sum[2] & correction_needed) | (raw_sum[2] & c0) | (correction_needed & c0);

    // Bit 3: raw_sum[3] + correction bit 3 (0) + c1
    assign Sum[3] = raw_sum[3] ^ c1;
    assign c2 = raw_sum[3] & c1;

    // 4. Carry out from correction addition or raw_sum carry out generates final Cout
    assign Cout = correction_needed ? (c2 | raw_sum[4]) : raw_sum[4];

endmodule