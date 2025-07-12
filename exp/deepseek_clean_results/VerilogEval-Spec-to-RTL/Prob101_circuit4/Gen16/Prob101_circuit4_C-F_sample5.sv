module TopModule (
    input  a,       // Unused input (required by interface)
    input  b,       // OR operand 1 - q = 1 when b=1
    input  c,       // OR operand 2 - q = 1 when c=1
    input  d,       // Unused input (required by interface)
    output q        // Output: Logical OR of b and c (q = b | c)
);
    /*
     * Truth Table Implementation:
     * a b c d | q
     * --------+--
     * x 0 0 x | 0
     * x 0 1 x | 1
     * x 1 0 x | 1
     * x 1 1 x | 1
     * Where x = don't care (0 or 1)
     *
     * Note: Inputs a and d are unused but maintained for interface compliance
     */

    assign q = b | c;  // Minimal implementation matching truth table

    /* Verification Reference:
     * Matches simulation waveforms exactly:
     * - q=0 only when both b=0 and c=0
     * - q=1 for all other combinations
     */
endmodule