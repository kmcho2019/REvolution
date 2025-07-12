/*
 * TopModule - 2-bit equality comparator
 * 
 * Inputs:
 *   A[1:0] - First 2-bit input
 *   B[1:0] - Second 2-bit input
 * Output:
 *   z      - 1 when A == B, 0 otherwise
 *
 * Implementation: Synthesizes to two XNOR gates (bitwise equality)
 *                 followed by an AND gate (all bits equal)
 */
module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Direct equality comparison (optimal synthesis)
    assign z = (A == B);
    
    /* Gate-level equivalent implementation:
     *   wire bit0_equal = ~(A[0] ^ B[0]);  // XNOR for LSB
     *   wire bit1_equal = ~(A[1] ^ B[1]);  // XNOR for MSB
     *   assign z = bit0_equal & bit1_equal; // AND gate
     */
endmodule