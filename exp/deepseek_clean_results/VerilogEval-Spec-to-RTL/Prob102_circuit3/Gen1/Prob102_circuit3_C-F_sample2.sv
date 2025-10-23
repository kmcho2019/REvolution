module TopModule (
    input a,    // First control input
    input b,    // Second control input
    input c,    // First data input
    input d,    // Second data input
    output q    // Output result
);

    // Output is true when:
    // (either control input a OR b is true)
    // AND
    // (either data input c OR d is true)
    assign q = (a | b) & (c | d);

endmodule