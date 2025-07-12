module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire a_gt_b = (A[3] & ~B[3]) |
                  ((A[3] == B[3]) & (A[2] & ~B[2])) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] & ~B[1])) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    wire a_lt_b = (~A[3] & B[3]) |
                  ((A[3] == B[3]) & (~A[2] & B[2])) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & (~A[1] & B[1])) |
                  ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (~A[0] & B[0]));

    wire a_eq_b = (A == B);

    assign A_greater = a_gt_b;
    assign A_less    = a_lt_b;
    assign A_equal   = a_eq_b;

endmodule