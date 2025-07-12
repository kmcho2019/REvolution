module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Directly implement the required logic using a single statement
    assign q = (a | b) & (c | d);

endmodule