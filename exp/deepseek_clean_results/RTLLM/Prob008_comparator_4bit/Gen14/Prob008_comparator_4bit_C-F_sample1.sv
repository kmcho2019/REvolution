module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check using XOR reduction (fastest path)
    wire equal = ~(|(A ^ B));

    // Shared bit equality signals
    wire eq3 = ~(A[3] ^ B[3]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq1 = ~(A[1] ^ B[1]);

    // Optimized hierarchical greater-than comparison
    wire greater = (A[3] & ~B[3]) |
                   (eq3 & A[2] & ~B[2]) |
                   (eq3 & eq2 & A[1] & ~B[1]) |
                   (eq3 & eq2 & eq1 & A[0] & ~B[0]);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule