module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // 'd' is a don't-care input and ignored in logic
    output out
);

// Simplified logic from the Karnaugh map using don't-care conditions
assign out = a | (c & ~b);

endmodule