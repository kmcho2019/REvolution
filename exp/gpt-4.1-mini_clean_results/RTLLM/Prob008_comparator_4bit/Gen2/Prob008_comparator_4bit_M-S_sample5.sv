module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire greater = (A[3] & ~B[3]) |
                   ((A[3] == B[3]) & (A[2] & ~B[2])) |
                   ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] & ~B[1])) |
                   ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    wire less = (~A[3] & B[3]) |
                ((A[3] == B[3]) & (~A[2] & B[2])) |
                ((A[3] == B[3]) & (A[2] == B[2]) & (~A[1] & B[1])) |
                ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (~A[0] & B[0]));

    wire equal = (A == B);

    assign A_greater = greater;
    assign A_less    = less;
    assign A_equal   = equal;

endmodule