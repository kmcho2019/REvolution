module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // Don't-care input, not used in this implementation
    output out
);

assign out = (a & b) | (~a & b & c) | (a & ~b & c);

endmodule