module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // q is asserted if at least one of (a or b) AND one of (c or d) is high
    assign q = (a | b) & (c | d);

endmodule