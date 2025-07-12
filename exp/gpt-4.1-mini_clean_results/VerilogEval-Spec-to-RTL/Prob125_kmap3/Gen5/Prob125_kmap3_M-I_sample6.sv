module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,      // don't-care input, not used in logic
    output out
);

// Implement minimized boolean expression from Karnaugh map
assign out = (~b & a) | (c & a) | (b & c);

endmodule