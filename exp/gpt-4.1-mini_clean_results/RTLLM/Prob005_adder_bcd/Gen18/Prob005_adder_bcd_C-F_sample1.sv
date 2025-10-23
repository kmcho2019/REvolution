module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Binary addition of A, B, and Cin (5-bit to hold carry out)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Correction detection
    // Correction needed if raw_sum > 9:
    // raw_sum > 9 if bit4 == 1 (carry out) or (bit3 & (bit2 | bit1))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditional BCD correction: add 6 (0110) when needed

    wire [3:0] sum_low = raw_sum[3:0];

    // Adding 6 (binary 0110) to sum_low if correction_needed
    // Implement 4-bit adder for sum_low + (correction_needed ? 6 : 0)

    // Bit 0: sum_low[0] + 0 + 0 = sum_low[0]
    wire c0 = 0;
    wire s0 = sum_low[0];

    // Bit 1: sum_low[1] + (correction_needed & 1) + carry_in
    wire s1 = sum_low[1] ^ correction_needed ^ c0;
    wire c1 = (sum_low[1] & correction_needed) | ((sum_low[1] ^ correction_needed) & c0);

    // Bit 2: sum_low[2] + (correction_needed & 1) + carry_in
    wire s2 = sum_low[2] ^ correction_needed ^ c1;
    wire c2 = (sum_low[2] & correction_needed) | ((sum_low[2] ^ correction_needed) & c1);

    // Bit 3: sum_low[3] + 0 + carry_in
    wire s3 = sum_low[3] ^ 1'b0 ^ c2;
    wire c3 = (sum_low[3] & 1'b0) | ((sum_low[3] ^ 1'b0) & c2);

    // Step 4: Select corrected sum bits if correction needed; else raw sum bits
    wire [3:0] corrected_sum = correction_needed ? {s3, s2, s1, s0} : sum_low;

    // Step 5: Carry out generation (from corrected sum carry or raw_sum[4])
    wire cout = correction_needed ? (c3 | raw_sum[4]) : raw_sum[4];

    // Assign outputs
    assign Sum  = corrected_sum;
    assign Cout = cout;

endmodule