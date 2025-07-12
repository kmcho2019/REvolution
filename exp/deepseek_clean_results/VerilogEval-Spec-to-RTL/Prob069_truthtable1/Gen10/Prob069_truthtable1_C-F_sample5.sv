module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Truth table implementation using optimized Boolean logic:
    // f = 1 when:
    //   (~x3 & x2) - first four rows where x3=0 and x2=1
    //   OR (x3 & x1) - last four rows where x3=1 and x1=1
    assign f = (~x3 & x2) | (x3 & x1);
endmodule