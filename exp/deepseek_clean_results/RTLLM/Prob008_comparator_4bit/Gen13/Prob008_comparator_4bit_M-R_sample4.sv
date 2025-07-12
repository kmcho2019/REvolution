module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct output assignments
    assign A_equal = &(A ~^ B);  // XNOR all bits for equality
    assign A_greater = (~A_equal) & ((A[3] & ~B[3]) |
                                   ((A[3] ~^ B[3]) & (A[2] & ~B[2])) |
                                   ((A[3:2] == B[3:2]) & (A[1] & ~B[1])) |
                                   ((A[3:1] == B[3:1]) & (A[0] & ~B[0])));
    assign A_less = (~A_equal) & (~A_greater);

endmodule