module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Directly implement the required logic using assign statement
    assign q = (a | b) & (c | d);

endmodule