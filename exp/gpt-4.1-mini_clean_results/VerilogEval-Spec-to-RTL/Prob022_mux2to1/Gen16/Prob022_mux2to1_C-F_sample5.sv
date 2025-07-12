// TopModule: 1-bit 2-to-1 Multiplexer (fused optimal solution)
// When sel=0, out = a; when sel=1, out = b.
// Continuous assignment ensures minimal logic levels and direct mux inference,
// promoting optimal delay and area.
// Synthesis tools typically recognize this pattern as a mux and optimize accordingly.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

// Synthesis directive to encourage mux optimization (tool dependent, optional)
// (* mux2to1 = "true" *) // Uncomment if tool supports such attribute

assign out = sel ? b : a;

endmodule