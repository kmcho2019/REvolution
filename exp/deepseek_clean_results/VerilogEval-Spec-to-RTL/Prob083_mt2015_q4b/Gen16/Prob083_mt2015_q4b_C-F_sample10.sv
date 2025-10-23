module TopModule (
    input x,
    input y,
    output z
);
    /* Truth Table:
     * x y | z
     * ----|---
     * 0 0 | 1  (both low)
     * 0 1 | 0  (different)
     * 1 0 | 0  (different)
     * 1 1 | 1  (both high)
     *
     * Implementation note:
     * This is equivalent to an XNOR gate operation (z = x ~^ y)
     * which is the most efficient implementation (single gate)
     */
    assign z = x ~^ y;
endmodule