module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Output is high when either a or b is high AND either c or d is high
    assign q = (a | b) & (c | d);

endmodule