module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    /*
    Truth table implementation:
    x3 x2 x1 | f
    ---------|---
    0  0  0  | 0
    0  0  1  | 0
    0  1  0  | 1
    0  1  1  | 1
    1  0  0  | 0
    1  0  1  | 1
    1  1  0  | 0
    1  1  1  | 1
    
    Boolean expression: f = (~x3 & x2) | (x3 & x1)
    Equivalent to: f = x3 ? x1 : x2
    */
    
    assign f = x3 ? x1 : x2;
endmodule