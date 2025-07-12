module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal fused implementation:
    // Clear separation of control and data paths in a single expression
    assign q = (a | b) & (c | d);

endmodule