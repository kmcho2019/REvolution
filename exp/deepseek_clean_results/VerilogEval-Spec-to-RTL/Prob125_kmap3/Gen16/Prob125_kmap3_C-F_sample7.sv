module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized version combining both approaches
    // When c=0: out = a (matches Example 2's case_c0)
    // When c=1: out = a | ~b (matches Example 2's case_c1)
    // Combined into single optimized expression from Example 1
    assign out = a | (~a & ~b & c);
endmodule