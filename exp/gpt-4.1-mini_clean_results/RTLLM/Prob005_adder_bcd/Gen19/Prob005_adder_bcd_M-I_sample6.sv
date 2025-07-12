module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: 4-bit binary addition with carry-out (5 bits)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Efficient Boolean logic to detect correction need
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Correction addition of 6 (0110) if needed, simplified combinational logic
    // Let s = raw_sum[3:0]
    // Correction addition (add 6) when correction_needed=1
    // Sum[0] = s0 (unchanged since LSB addition with 0)
    // Sum[1] = s1 XOR correction_bit1 = s1 ^ 1
    // Sum[2] = s2 XOR correction_bit2 = s2 ^ 1
    // Sum[3] = s3 XOR correction_bit3 = s3 ^ 0 = s3
    // But need to consider carry between bits due to addition:
    //
    // Instead of ripple carry, derive direct expressions for corrected bits:
    // Adding 6 (0110) means:
    // Bit0: s0 + 0 = s0
    // Bit1: s1 + 1 + carry_in0 (carry_in0=0) = s1 + 1 => sum1 = ~s1, carry1 = s1
    // Bit2: s2 + 1 + carry1
    //   sum2 = s2 ^ 1 ^ carry1 = s2 ^ 1 ^ s1
    //   carry2 = (s2&1) | ((s2^1)&s1) = s2 | ( (~s2) & s1 ) = s2 | s1&~s2
    // Bit3: s3 + 0 + carry2
    //   sum3 = s3 ^ 0 ^ carry2 = s3 ^ carry2
    //   carry3 = s3 & carry2
    //
    // Using this logic, directly generate corrected sum bits without ripple carry chain.

    wire s0 = raw_sum[0];
    wire s1 = raw_sum[1];
    wire s2 = raw_sum[2];
    wire s3 = raw_sum[3];

    // Correction bits addition when correction_needed
    wire c_sum0 = s0;
    wire c_sum1 = ~s1;
    wire c_carry1 = s1;

    wire c_sum2 = s2 ^ 1'b1 ^ c_carry1;
    wire c_carry2 = (s2 & 1'b1) | ((s2 ^ 1'b1) & c_carry1);

    wire c_sum3 = s3 ^ c_carry2;
    wire c_carry3 = s3 & c_carry2;

    // Select final sum bits based on correction_needed
    assign Sum[0] = correction_needed ? c_sum0 : s0;
    assign Sum[1] = correction_needed ? c_sum1 : s1;
    assign Sum[2] = correction_needed ? c_sum2 : s2;
    assign Sum[3] = correction_needed ? c_sum3 : s3;

    // Carry out is OR of raw carry (bit 4) and correction carry out
    assign Cout = raw_sum[4] | (correction_needed & c_carry3);

endmodule