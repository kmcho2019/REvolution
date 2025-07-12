module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality check: all bits match
    wire eq = &(~(A ^ B));

    // A greater than B detection using bitwise comparison from MSB to LSB
    wire a_gt_b = (A[3] & ~B[3]) |
                  ((A[3] == B[3]) & A[2] & ~B[2]) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & A[1] & ~B[1]) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & A[0] & ~B[0]);

    // A less than B detection as the inverse of greater and equal
    wire a_lt_b = ~eq & ~a_gt_b;

    assign A_equal   = eq;
    assign A_greater = a_gt_b;
    assign A_less    = a_lt_b;

endmodule