module TopModule (
    input [1:0] A,  // First 2-bit input
    input [1:0] B,  // Second 2-bit input
    output z        // Outputs 1 when A equals B, 0 otherwise
);
    // Direct equality comparison - most efficient implementation
    assign z = (A == B);
endmodule