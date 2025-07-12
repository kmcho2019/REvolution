module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Power-efficient equality detection (single cycle)
    wire all_equal = (A == B);

    // Optimized hierarchical comparison
    wire gt3 = (A[3] > B[3]);
    wire eq3 = (A[3] == B[3]);
    
    wire gt2 = (A[2] > B[2]);
    wire eq2 = (A[2] == B[2]);
    
    wire gt1 = (A[1] > B[1]);
    wire eq1 = (A[1] == B[1]);
    
    wire gt0 = (A[0] > B[0]);

    // Early termination comparison logic
    wire greater = gt3 | 
                  (eq3 & gt2) | 
                  (eq3 & eq2 & gt1) | 
                  (eq3 & eq2 & eq1 & gt0);

    // Output logic with built-in mutual exclusivity
    assign A_equal  = all_equal;
    assign A_greater = ~all_equal & greater;
    assign A_less   = ~all_equal & ~greater;

endmodule