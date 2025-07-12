module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    /*
     * Optimal combinational logic implementation with:
     * - Control path: (a OR b) acts as enable condition
     * - Data path: (c OR d) provides the data condition
     * 
     * Technology Optimization Notes:
     * 1. Can be implemented with 3 basic gates (2 OR + 1 AND)
     * 2. AO22 complex cell could reduce to single gate if available
     * 3. Gate ordering could be optimized based on signal probabilities
     */
    assign q = (a | b) & (c | d);
endmodule