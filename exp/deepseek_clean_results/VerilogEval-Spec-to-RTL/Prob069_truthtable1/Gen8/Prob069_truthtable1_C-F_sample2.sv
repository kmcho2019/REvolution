module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    /* Truth table mapping:
     * x3 x2 x1 | f
     * ---------|---
     * 0  0  0  | 0
     * 0  0  1  | 0
     * 0  1  0  | 1  (~x3 & x2)
     * 0  1  1  | 1  (~x3 & x2)
     * 1  0  0  | 0
     * 1  0  1  | 1  (x3 & x1)
     * 1  1  0  | 0
     * 1  1  1  | 1  (x3 & x1)
     */
    assign f = (~x3 & x2) | (x3 & x1);
endmodule