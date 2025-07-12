module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Optimal and minimal direct implementation of q = (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);

endmodule