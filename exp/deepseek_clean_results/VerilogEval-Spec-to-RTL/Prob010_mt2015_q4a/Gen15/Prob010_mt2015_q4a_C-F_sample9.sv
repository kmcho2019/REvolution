module TopModule (
    input x,
    input y,
    output z
);
    /* Implementation of z = (x^y) & x
     * Optimized equivalent: x & (x ^ y)
     * - Same functionality as original spec
     * - Better PPA than (x^y) & x implementation
     * - Clear relationship to specification
     */
    assign z = x & (x ^ y);
endmodule