module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;

    // 4-bit binary addition with carry out
    assign bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if BCD correction needed:
    // Condition: sum > 9, which can be detected as:
    // bin_sum[4] == carry out OR
    // (bin_sum[3] & (bin_sum[2] | bin_sum[1]))
    wire correction = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Perform BCD correction without a second adder:
    // Add 6 (0110) if correction is needed.
    // Correction addition broken down bitwise:
    // sum[0] = bin_sum[0] ^ correction
    // carry0 = bin_sum[0] & correction
    // sum[1] = bin_sum[1] ^ correction ^ carry0
    // carry1 = (bin_sum[1] & correction) | (bin_sum[1] & carry0) | (correction & carry0)
    // sum[2] = bin_sum[2] ^ carry1
    // carry2 = bin_sum[2] & carry1
    // sum[3] = bin_sum[3] ^ carry2
    // Cout = bin_sum[4] | carry2

    wire c0 = bin_sum[0] & correction;
    wire s0 = bin_sum[0] ^ correction;

    wire c1 = (bin_sum[1] & correction) | (bin_sum[1] & c0) | (correction & c0);
    wire s1 = bin_sum[1] ^ correction ^ c0;

    wire c2 = bin_sum[2] & c1;
    wire s2 = bin_sum[2] ^ c1;

    wire s3 = bin_sum[3] ^ c2;
    wire cout_final = bin_sum[4] | c2;

    assign Sum = {s3, s2, s1, s0};
    assign Cout = cout_final;

endmodule