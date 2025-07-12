module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is high only when:
    // 1. At least one of a or b is high (first condition)
    // AND
    // 2. At least one of c or d is high (second condition)
    assign q = ((a || b) ? 1'b1 : 1'b0) & ((c || d) ? 1'b1 : 1'b0);

endmodule