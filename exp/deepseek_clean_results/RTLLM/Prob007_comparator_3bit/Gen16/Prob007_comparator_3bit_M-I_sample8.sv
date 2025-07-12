module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct comparison logic with optimized structure
assign A_equal = &(~(A ^ B));  // Single 3-input AND for equality

// MSB comparison with mid-bit and LSB terms
assign A_greater = (A[2] & ~B[2]) | 
                  (~(A[2] ^ B[2]) & (A[1] & ~B[1])) | 
                  (&(~(A[2:1] ^ B[2:1])) & (A[0] & ~B[0]));

// Direct A_less calculation (optimized for power)
assign A_less = (~A[2] & B[2]) | 
               (~(A[2] ^ B[2]) & (~A[1] & B[1])) | 
               (&(~(A[2:1] ^ B[2:1])) & (~A[0] & B[0]));

endmodule