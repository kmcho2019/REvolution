module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized fused implementation:
    // When a=1: output 1 (from Example 2)
    // When a=0: output c ? ~b : 0 (from Example 1's c=1 case)
    assign out = a ? 1'b1 : (c ? ~b : 1'b0);
endmodule