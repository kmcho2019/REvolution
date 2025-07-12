module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal implementation combining:
    // - Direct logic expression for best PPA (from Example 2)
    // - Clear functional description (from Example 1)
    // Equivalent to: in1 AND (NOT in2)
    assign out = in1 & ~in2;
endmodule