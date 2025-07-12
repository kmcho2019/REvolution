module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Truth table implementation:
    // x3 x2 x1 | f
    // ---------|---
    // 0  0  0  | 0
    // 0  0  1  | 0
    // 0  1  0  | 1
    // 0  1  1  | 1
    // 1  0  0  | 0
    // 1  0  1  | 1
    // 1  1  0  | 0
    // 1  1  1  | 1
    //
    // Implementation note:
    // The output can be expressed as: f = x3 ? x1 : x2
    // When x3=0, output follows x2 (rows 1-4)
    // When x3=1, output follows x1 (rows 5-8)
    
    assign f = x3 ? x1 : x2;
endmodule