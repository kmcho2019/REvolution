module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Implement equality as bitwise XNOR + AND
    wire a1_eq_b1 = ~(A[1] ^ B[1]);  // XNOR for MSB
    wire a0_eq_b0 = ~(A[0] ^ B[0]);  // XNOR for LSB
    
    assign z = a1_eq_b1 & a0_eq_b0;  // Final AND
    
    /* Implementation notes:
     * - Shows the underlying gate-level implementation of equality
     * - Each XNOR checks bit equality
     * - Final AND combines the results
     * - Synthesizes to same PPA as direct comparison
     * - Demonstrates how equality operator works internally
     */
endmodule