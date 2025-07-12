// TopModule: 1-bit 2-to-1 Multiplexer using continuous assignment
// When sel=0, out = a; when sel=1, out = b.
// This implementation is minimal, efficient, and clear.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

// Multiplexer logic: select between a and b based on sel
assign out = sel ? b : a;

endmodule