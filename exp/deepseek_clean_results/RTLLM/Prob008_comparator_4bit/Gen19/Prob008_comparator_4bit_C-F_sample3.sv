module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality comparison (most efficient)
    wire equal = (A == B);
    
    // Optimized hierarchical greater-than comparison
    wire greater;
    assign greater = (A[3] > B[3]) ? 1'b1 :
                    (A[3] < B[3]) ? 1'b0 :
                    (A[2] > B[2]) ? 1'b1 :
                    (A[2] < B[2]) ? 1'b0 :
                    (A[1] > B[1]) ? 1'b1 :
                    (A[1] < B[1]) ? 1'b0 :
                    (A[0] > B[0]);

    // Final outputs (optimized to minimize logic)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule