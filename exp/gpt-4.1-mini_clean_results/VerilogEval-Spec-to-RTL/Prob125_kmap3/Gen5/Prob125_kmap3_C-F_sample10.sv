module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, unused in logic
    output out
);

// Intermediate inverted signals for clarity
wire not_b = ~b;

// Minimal logic from Karnaugh map:
// out = a OR (c AND NOT b)
// 'd' is don't-care and ignored, no impact on logic.

// This representation enhances readability and potential debugging,
// while preserving minimal gate count and logic depth.

assign out = a | (c & not_b);

endmodule