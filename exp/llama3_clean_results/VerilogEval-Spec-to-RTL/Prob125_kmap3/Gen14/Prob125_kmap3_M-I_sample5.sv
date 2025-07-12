module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// The expression directly implements the required logic from the Karnaugh map
// and is already optimized for simplicity and correctness.
assign out = a | (~a & ~b & c);

endmodule