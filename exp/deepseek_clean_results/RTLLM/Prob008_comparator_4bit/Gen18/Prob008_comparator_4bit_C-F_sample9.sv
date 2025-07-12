module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality comparison (from Example 2)
    wire equal = (A == B);
    
    // Optimized hierarchical greater-than (fusion of both examples)
    wire greater = (A[3] & ~B[3]) |                            // MSB comparison
                  (~(A[3] ^ B[3]) & (A[2] & ~B[2])) |         // Next bit if equal
                  (~(|(A[3:2] ^ B[3:2])) & (A[1] & ~B[1])) |  // Next bit if equal
                  (~(|(A[3:1] ^ B[3:1])) & (A[0] & ~B[0]));   // LSB if all higher equal

    // Final outputs (optimized from both examples)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule