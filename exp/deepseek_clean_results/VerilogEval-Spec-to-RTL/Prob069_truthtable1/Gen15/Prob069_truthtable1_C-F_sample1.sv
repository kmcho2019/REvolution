module TopModule (
    input x3,    // Select signal: 0 chooses x2, 1 chooses x1
    input x2,    // Output source when x3=0
    input x1,    // Output source when x3=1
    output f     // Output: f = x3 ? x1 : x2
);
    // Truth table implementation using optimal mux structure
    // x3 x2 x1 | f
    // 0  0  0 | 0
    // 0  0  1 | 0
    // 0  1  0 | 1
    // 0  1  1 | 1
    // 1  0  0 | 0
    // 1  0  1 | 1
    // 1  1  0 | 0
    // 1  1  1 | 1
    assign f = x3 ? x1 : x2;
endmodule