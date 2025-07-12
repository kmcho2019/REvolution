module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output out
);

// Karnaugh map solution:
// out = a OR (c AND NOT b)
// 'd' input is don't-care and not used in logic, can be tied to any value.

// This is a minimal sum-of-products expression minimizing gate count and logic levels.
// It ensures minimal delay, area, and power in typical CMOS libraries.

// Implemented with bitwise operators for clarity and synthesis friendliness.

assign out = a | (c & ~b);

endmodule