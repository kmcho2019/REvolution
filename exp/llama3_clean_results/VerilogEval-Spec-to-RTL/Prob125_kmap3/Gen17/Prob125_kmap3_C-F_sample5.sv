module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Using a continuous assignment for potential area and power efficiency
// The logic expression directly implements the required logic based on the Karnaugh map
assign out = a | (~a & ~b & c);

endmodule