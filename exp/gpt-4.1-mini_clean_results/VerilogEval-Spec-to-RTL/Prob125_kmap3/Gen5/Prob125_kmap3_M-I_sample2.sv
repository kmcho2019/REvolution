module TopModule(
    input a,
    input b,
    input c,
    input d,      // don't-care input, not used
    output out
);

// Minimal logic covering the given K-map:
// out = a + c * (~b)
assign out = a | (c & ~b);

endmodule