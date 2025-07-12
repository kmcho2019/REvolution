module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Output is 1 when:
    // 1. x3=0 and x2=1 (first four rows of truth table)
    // OR
    // 2. x3=1 and x1=1 (last four rows of truth table)
    assign f = (~x3 & x2) | (x3 & x1);
endmodule