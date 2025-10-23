module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;

    // 4-bit addition with carry-in
    assign raw_sum = A + B + Cin;

    // Overflow detection (BCD sum > 9)
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // BCD correction logic without full adder:
    // Corrected sum = raw_sum + 6 if overflow else raw_sum

    // Using direct combinational logic derived from truth tables for corrected sum bits:
    // Let S = raw_sum[3:0]
    wire s3 = raw_sum[3];
    wire s2 = raw_sum[2];
    wire s1 = raw_sum[1];
    wire s0 = raw_sum[0];

    // Corrected sum bits according to BCD addition correction logic:
    assign Sum[0] = overflow ? ~s0 : s0;
    assign Sum[1] = overflow ? (~s1 & s0) | (s1 & ~s0) : s1;
    assign Sum[2] = overflow ? ~s2 : s2;
    assign Sum[3] = overflow ? s3 | s2 : s3;

    // Carry out is overflow
    assign Cout = overflow;

endmodule