module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Optimized hierarchical magnitude comparison
    wire gt3 = A[3] & ~B[3];
    wire eq3 = ~(A[3] ^ B[3]);
    
    wire gt2 = A[2] & ~B[2];
    wire eq2 = ~(A[2] ^ B[2]);
    
    wire gt1 = A[1] & ~B[1];
    wire eq1 = ~(A[1] ^ B[1]);
    
    wire gt0 = A[0] & ~B[0];
    
    // Priority-based greater-than determination
    wire greater = gt3 | 
                  (eq3 & gt2) | 
                  (eq3 & eq2 & gt1) | 
                  (eq3 & eq2 & eq1 & gt0);

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule