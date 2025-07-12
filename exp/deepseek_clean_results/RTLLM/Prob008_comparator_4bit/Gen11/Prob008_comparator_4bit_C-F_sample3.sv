module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check (fastest path)
    wire equal = (A == B);
    
    // Optimized hierarchical magnitude comparison
    wire gt = (A[3] > B[3]) |
              ((A[3] == B[3]) & (A[2] > B[2])) |
              ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] > B[1])) |
              ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (A[0] > B[0]));

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & gt;
    assign A_less = ~equal & ~gt;

endmodule