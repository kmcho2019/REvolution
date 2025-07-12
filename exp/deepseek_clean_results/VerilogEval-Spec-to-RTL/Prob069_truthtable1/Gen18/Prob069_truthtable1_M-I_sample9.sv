module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Truth table:
    // x3 x2 x1 | f
    // 0  0  0  | 0
    // 0  0  1  | 0
    // 0  1  0  | 1
    // 0  1  1  | 1
    // 1  0  0  | 0
    // 1  0  1  | 1
    // 1  1  0  | 0
    // 1  1  1  | 1
    assign f = x3 ? x1 : x2;
endmodule