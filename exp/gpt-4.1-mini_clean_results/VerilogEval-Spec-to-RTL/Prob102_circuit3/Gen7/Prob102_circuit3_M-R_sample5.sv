module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Implement q = (a OR b) AND (c OR d) directly using logical operators
    assign q = (a | b) & (c | d);

endmodule