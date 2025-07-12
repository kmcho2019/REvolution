module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise equality (XNOR for lower power)
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Fast parallel equality check
    wire equal = &bit_eq;
    
    // Optimized greater-than detection with early termination
    wire gt3 = A[3] & ~B[3];
    wire eq3 = bit_eq[3];
    wire gt2 = A[2] & ~B[2];
    wire eq2 = bit_eq[2];
    wire gt1 = A[1] & ~B[1];
    wire eq1 = bit_eq[1];
    wire gt0 = A[0] & ~B[0];
    
    wire greater = gt3 | 
                  (eq3 & gt2) | 
                  (eq3 & eq2 & gt1) | 
                  (eq3 & eq2 & eq1 & gt0);
    
    // Output logic with guaranteed mutual exclusivity
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule