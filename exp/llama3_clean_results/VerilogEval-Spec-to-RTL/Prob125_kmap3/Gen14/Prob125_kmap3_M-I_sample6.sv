module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Use a continuous assignment for potential area and power efficiency
// The expression directly implements the required logic from the Karnaugh map
assign out = a | (~a & ~b & c);

endmodule