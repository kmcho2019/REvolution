module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // q is asserted when either a or b is high AND either c or d is high
    assign q = (a | b) & (c | d);
endmodule