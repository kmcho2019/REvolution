module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Compare LSBs first
    wire lsb_equal = ~(A[0] ^ B[0]);
    
    // Compare MSBs and combine with LSB result
    wire msb_equal = ~(A[1] ^ B[1]);
    
    // Final equality is AND of both bit comparisons
    assign z = lsb_equal & msb_equal;
endmodule