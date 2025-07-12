module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output out
);

// From Karnaugh map and don't-care 'd':
// out = a OR (c AND NOT b)
// This is the minimal sum-of-products expression minimizing gates and logic levels.

assign out = a | (c & ~b);

endmodule