module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// The simplified expression remains largely the same due to the direct implementation of the required logic.
assign out = a | (~a & ~b & c);

endmodule