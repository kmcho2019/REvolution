module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Early equality check (most power-efficient path when equal)
    wire equal = (A == B);
    
    // Efficient borrow calculation (only what's needed for less-than)
    wire borrow = (A < B);
    
    // Optimized greater-than using hierarchical bit comparison
    wire gt3 = A[3] & ~B[3];
    wire eq3 = A[3] == B[3];
    wire gt2 = A[2] & ~B[2];
    wire eq2 = A[1:0] == B[1:0];
    wire gt1 = A[1] & ~B[1];
    wire gt0 = A[0] & ~B[0];
    
    wire greater = gt3 | 
                  (eq3 & gt2) | 
                  (eq3 & (A[2] == B[2]) & gt1) | 
                  (eq3 & (A[2] == B[2]) & (A[1] == B[1]) & gt0);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = borrow;

endmodule