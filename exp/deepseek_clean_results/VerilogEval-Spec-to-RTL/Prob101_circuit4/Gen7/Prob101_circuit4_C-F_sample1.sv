module TopModule (
    input  a,       // Don't-care input (unused in logic)
    input  b,       // Primary logic input
    input  c,       // Primary logic input
    input  d,       // Don't-care input (unused in logic)
    output q        // Output = b OR c
);

    // Optimal implementation using minimal logic
    assign q = b | c;

    /* Truth Table Reference:
     *  b c | q
     * ------+--
     *  0 0 | 0
     *  0 1 | 1
     *  1 0 | 1
     *  1 1 | 1
     */
endmodule