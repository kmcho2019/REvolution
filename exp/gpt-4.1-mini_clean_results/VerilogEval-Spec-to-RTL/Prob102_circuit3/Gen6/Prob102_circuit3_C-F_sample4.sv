module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Output q is asserted when either input a or b is high AND
    // either input c or d is high. This matches the observed waveform
    // and represents the logic function: q = (a OR b) AND (c OR d).
    assign q = (a | b) & (c | d);

endmodule