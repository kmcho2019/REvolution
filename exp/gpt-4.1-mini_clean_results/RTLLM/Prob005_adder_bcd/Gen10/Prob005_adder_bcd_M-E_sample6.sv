module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: 4-bit binary addition with carry out
    wire [4:0] binary_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Detect if correction needed
    // Correction needed if sum > 9:
    // sum > 9 if MSB (bit4) is set (sum > 15) OR
    // sum[3] = 1 and (sum[2] OR sum[1]) = 1, indicating sum is between 10-15
    wire correction_needed = (binary_sum[4]) | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Step 3: If correction needed, add 6 (0110) to lower 4 bits of binary_sum
    // Implement a small 4-bit ripple carry adder for correction:
    wire [3:0] addend = 4'b0110;
    wire [3:0] corrected_sum;
    wire       correction_carry;

    // Ripple carry adder for correction addition: sum + 6 when correction_needed, else just pass sum
    // Instantiate full adders for each bit:

    // Bit 0
    wire c0 = 1'b0;
    wire s0, c1;
    assign s0 = binary_sum[0] ^ (correction_needed & addend[0]) ^ c0;
    assign c1 = (binary_sum[0] & (correction_needed & addend[0])) | ((binary_sum[0] ^ (correction_needed & addend[0])) & c0);

    // Bit 1
    wire s1, c2;
    assign s1 = binary_sum[1] ^ (correction_needed & addend[1]) ^ c1;
    assign c2 = (binary_sum[1] & (correction_needed & addend[1])) | ((binary_sum[1] ^ (correction_needed & addend[1])) & c1);

    // Bit 2
    wire s2, c3;
    assign s2 = binary_sum[2] ^ (correction_needed & addend[2]) ^ c2;
    assign c3 = (binary_sum[2] & (correction_needed & addend[2])) | ((binary_sum[2] ^ (correction_needed & addend[2])) & c2);

    // Bit 3
    wire s3, c4;
    assign s3 = binary_sum[3] ^ (correction_needed & addend[3]) ^ c3;
    assign c4 = (binary_sum[3] & (correction_needed & addend[3])) | ((binary_sum[3] ^ (correction_needed & addend[3])) & c3);

    assign corrected_sum = {s3, s2, s1, s0};
    assign correction_carry = c4;

    // Final outputs
    assign Sum = corrected_sum;
    // Final carry is either original carry out (if no correction) or correction_carry if correction was applied
    assign Cout = correction_needed ? correction_carry : binary_sum[4];

endmodule