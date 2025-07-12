module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Direct combinational implementation: q = (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);

endmodule