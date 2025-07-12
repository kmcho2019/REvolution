module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

// Simplified expression derived from Karnaugh map analysis:
// out = a | (c & ~b)
assign out = a | (c & ~b);

endmodule