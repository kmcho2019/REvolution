module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal signals for comparison results
    wire [3:0] a_greater_than_b;
    wire [3:0] a_less_than_b;
    wire [3:0] a_equal_b;

    // Bitwise comparison using XOR
    assign a_equal_b[3] = ~(A[3] ^ B[3]);
    assign a_equal_b[2] = ~(A[2] ^ B[2]);
    assign a_equal_b[1] = ~(A[1] ^ B[1]);
    assign a_equal_b[0] = ~(A[0] ^ B[0]);

    // Determining greater than or less than
    assign a_greater_than_b[3] = (A[3] & ~B[3]);
    assign a_less_than_b[3] = (~A[3] & B[3]);

    assign a_greater_than_b[2] = (A[2] & ~B[2]) & a_equal_b[3];
    assign a_less_than_b[2] = (~A[2] & B[2]) & a_equal_b[3];

    assign a_greater_than_b[1] = (A[1] & ~B[1]) & a_equal_b[3] & a_equal_b[2];
    assign a_less_than_b[1] = (~A[1] & B[1]) & a_equal_b[3] & a_equal_b[2];

    assign a_greater_than_b[0] = (A[0] & ~B[0]) & a_equal_b[3] & a_equal_b[2] & a_equal_b[1];
    assign a_less_than_b[0] = (~A[0] & B[0]) & a_equal_b[3] & a_equal_b[2] & a_equal_b[1];

    // Final output logic
    assign A_greater = a_greater_than_b[3] | a_greater_than_b[2] | a_greater_than_b[1] | a_greater_than_b[0];
    assign A_less = a_less_than_b[3] | a_less_than_b[2] | a_less_than_b[1] | a_less_than_b[0];
    assign A_equal = a_equal_b[3] & a_equal_b[2] & a_equal_b[1] & a_equal_b[0];

endmodule