module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// The expression remains the same as it directly implements the required logic
// in a simplified manner.
assign out = a | (~a & ~b & c);

endmodule