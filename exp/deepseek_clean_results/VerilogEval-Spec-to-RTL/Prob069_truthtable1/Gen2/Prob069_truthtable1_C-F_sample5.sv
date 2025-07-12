module TopModule (
    input x3,
    input x2,
    input x1,
    output result
);
    // Implements truth table where result is true when:
    // - x3 is 0 and x2 is 1, OR
    // - x3 is 1 and x1 is 1
    assign result = (~x3 & x2) | (x3 & x1);
endmodule