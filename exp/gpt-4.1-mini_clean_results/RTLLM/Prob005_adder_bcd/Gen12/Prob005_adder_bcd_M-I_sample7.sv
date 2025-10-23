module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       overflow;

    // Step 1: Add inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Detect overflow: sum > 9
    // sum > 9 if (raw_sum[4] == 1) OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Compute corrected sum bits without a second adder
    // Correction = 6 (0110) added if overflow
    // We'll use combinational logic based on raw_sum and overflow:

    // Intermediate signals for the corrected sum bits:
    // The logic is derived from truth table of (raw_sum + 6 if overflow)

    wire c0 = raw_sum[0];
    wire c1 = raw_sum[1];
    wire c2 = raw_sum[2];
    wire c3 = raw_sum[3];
    wire c4 = raw_sum[4];

    // Calculate each bit of corrected sum:
    // Sum[0] = raw_sum[0] XOR overflow
    assign Sum[0] = c0 ^ overflow;

    // Sum[1] = raw_sum[1] XOR overflow
    assign Sum[1] = c1 ^ overflow;

    // Sum[2] = raw_sum[2] XOR overflow;
    // When adding 6 (0110), bits 1 and 2 toggle in correction
    assign Sum[2] = c2 ^ overflow;

    // Sum[3] = raw_sum[3] XOR overflow & ~raw_sum[2];
    // More precise logic is needed for this bit:
    // From truth table of sum+6 for overflow cases,
    // Sum[3] = (c3 & ~overflow) | (~c3 & c2 & overflow) | (c3 & c2 & overflow)
    // Simplify: Sum[3] = c3 ^ (overflow & (~c2 | c2))?
    // Actually, better to write as:
    assign Sum[3] = (c3 & ~overflow) | (overflow & (c2 | c3));

    // Step 4: Carry out is 1 when overflow or raw_sum[4] (the fifth bit) is set after correction
    // Using the overflow as the carry out because sum >9 means carry to next digit
    assign Cout = overflow;

endmodule