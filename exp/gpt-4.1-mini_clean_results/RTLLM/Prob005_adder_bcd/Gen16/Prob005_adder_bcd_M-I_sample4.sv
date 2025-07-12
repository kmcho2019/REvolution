module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;

    // Add inputs and carry-in (5 bits to include carry)
    assign raw_sum = A + B + Cin;

    // Detect BCD overflow (sum > 9)
    // Overflow if raw_sum > 9:
    // overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // BCD correction without adder:
    // When overflow=1, add 6 (0110) to raw_sum[3:0]
    // corrected_sum = raw_sum + 6 if overflow else raw_sum
    // Implement logic for corrected sum bits explicitly:

    // Let's define raw_sum bits for convenience
    wire r0 = raw_sum[0];
    wire r1 = raw_sum[1];
    wire r2 = raw_sum[2];
    wire r3 = raw_sum[3];

    // Correction adding 6 when overflow:
    // Adding 6 to raw_sum means:
    // sum0 = r0 (LSB) (since 6's LSB is 0, sum0 flips if adding 6 only if overflow and carry-in)
    // sum1 = r1 ^ overflow (bit 1 toggles when adding 1 to bit 1)
    // sum2 = ~(r2 ^ overflow) (bit 2 toggles and carry chain applies)
    // sum3 = r3 ^ overflow

    // However, to keep correctness, it's easier to implement a minimal ripple carry adder for correction on 4 bits,
    // but since the correction value is constant, we can implement the sum bits with the equations below:

    // We'll implement the addition raw_sum[3:0] + (overflow ? 6 : 0) using simple boolean equations:

    // bit 0 of correction value is 0 -> sum bit0 = raw_sum[0]
    wire sum0 = r0;

    // bit 1: sum1 = raw_sum[1] ^ overflow
    wire sum1 = r1 ^ overflow;

    // bit 2: sum2 = raw_sum[2] ^ overflow ^ (r1 & overflow)
    wire carry1 = r1 & overflow;
    wire sum2 = r2 ^ overflow ^ carry1;

    // bit 3: sum3 = raw_sum[3] ^ (overflow & (r2 | carry1))
    wire carry2 = (r2 & overflow) | (carry1 & overflow);
    wire sum3 = r3 ^ carry2;

    // Cout = raw_sum[4] | (overflow & (r3 & (r2 | r1)))
    // For correctness, use raw_sum[4] as carry out since raw_sum is 5 bits
    assign Cout = raw_sum[4] | (overflow & (r3 & (r2 | r1)));

    assign Sum = {sum3, sum2, sum1, sum0};

endmodule