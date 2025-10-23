module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Equality check (all bits equal)
    assign A_equal = (A == B);

    // Greater-than check with priority encoding
    assign A_greater = (A[3] > B[3]) ||
                      (A[3] == B[3] && A[2] > B[2]) ||
                      (A[3] == B[3] && A[2] == B[2] && A[1] > B[1]) ||
                      (A[3] == B[3] && A[2] == B[2] && A[1] == B[1] && A[0] > B[0]);

    // Less-than is simply neither equal nor greater
    assign A_less = ~A_equal & ~A_greater;

endmodule