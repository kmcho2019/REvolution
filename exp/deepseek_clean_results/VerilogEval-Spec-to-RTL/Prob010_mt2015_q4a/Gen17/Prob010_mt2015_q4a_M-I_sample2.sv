module TopModule (
    input x,
    input y,
    output z
);
    /* Implementation of z = (x^y) & x
     * Further optimized equivalent: x & ~y
     * - Mathematically equivalent to original spec since (x^y) & x = x & ~y
     * - Better PPA: single gate operation instead of two
     * - Clear relationship to specification through documentation
     */
    assign z = x & ~y;
endmodule