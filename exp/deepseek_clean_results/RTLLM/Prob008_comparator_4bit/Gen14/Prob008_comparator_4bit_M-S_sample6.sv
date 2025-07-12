module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Equality check (all bits equal)
    wire equal = (A == B);

    // Priority-encoded greater/less check
    wire greater = (A[3] > B[3]) ||
                 (A[3] == B[3] && A[2] > B[2]) ||
                 (A[3] == B[3] && A[2] == B[2] && A[1] > B[1]) ||
                 (A[3] == B[3] && A[2] == B[2] && A[1] == B[1] && A[0] > B[0]);

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule