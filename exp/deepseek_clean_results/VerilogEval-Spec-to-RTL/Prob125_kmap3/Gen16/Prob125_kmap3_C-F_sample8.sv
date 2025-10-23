module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized fused solution:
    // 1. Output is 1 when a=1 (from Example 2)
    // 2. Otherwise output is (a | ~b) when c=1 (from Example 1)
    // 3. Simplified to single expression: out = a | (~a & c & ~b)
    assign out = a | (~a & c & ~b);
endmodule