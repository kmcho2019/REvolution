module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise XOR to identify differing bits
    wire [3:0] xor_result;
    assign xor_result = A ^ B;

    // Determine if A and B are equal
    assign A_equal = ~(|xor_result); // A_equal is 1 if all bits of xor_result are 0

    // Determine if A is greater than B
    wire [3:0] and_result;
    assign and_result = (A & ~B) & ~xor_result[3:1];
    assign A_greater = |and_result; // A_greater is 1 if any bit of and_result is 1

    // Determine if A is less than B
    wire [3:0] or_result;
    assign or_result = (B & ~A) & ~xor_result[3:1];
    assign A_less = |or_result; // A_less is 1 if any bit of or_result is 1

endmodule