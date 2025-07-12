module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Combinational logic derived from waveform:
    // q = (a OR b) AND (c OR d)
    // This minimal expression matches all output conditions optimally.
    assign q = (a | b) & (c | d);

endmodule