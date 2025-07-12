module TopModule (
    input  a,       // Unused input (don't-care)
    input  b,       // Primary logic input
    input  c,       // Primary logic input
    input  d,       // Unused input (don't-care)
    output q        // Output function: b OR c
);

    // Minimal implementation using direct OR operation
    assign q = b | c;

    /* Complete Truth Table:
     *  b c | q
     * ------+--
     *  0 0 | 0
     *  0 1 | 1
     *  1 0 | 1
     *  1 1 | 1
     * 
     * Note: Inputs a and d have no effect on output q
     */
endmodule