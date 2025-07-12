module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity using a chain of XNOR gates
    // This expression corresponds exactly to the waveform outputs,
    // and synthesis tools often optimize chained XNOR efficiently.
    assign q = a ~^ b ~^ c ~^ d;

endmodule