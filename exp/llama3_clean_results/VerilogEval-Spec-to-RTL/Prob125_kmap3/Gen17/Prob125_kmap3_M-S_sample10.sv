module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// The existing expression directly implements the required logic
// and is already optimized for simplicity and functionality.
assign out = a | (~a & ~b & c);

endmodule