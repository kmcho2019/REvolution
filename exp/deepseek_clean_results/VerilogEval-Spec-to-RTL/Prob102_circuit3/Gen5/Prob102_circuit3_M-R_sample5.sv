module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Simplified direct implementation:
    // q is high when at least one of a/b AND at least one of c/d is high
    assign q = (a || b) && (c || d);

endmodule