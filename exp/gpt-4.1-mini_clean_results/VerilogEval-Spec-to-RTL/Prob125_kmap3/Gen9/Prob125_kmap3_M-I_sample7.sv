module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,  // don't-care input, intentionally unused
    output wire out
);

// Minimal logic expression derived from Karnaugh map:
// out = a + c * !b
assign out = a | (c & ~b);

endmodule