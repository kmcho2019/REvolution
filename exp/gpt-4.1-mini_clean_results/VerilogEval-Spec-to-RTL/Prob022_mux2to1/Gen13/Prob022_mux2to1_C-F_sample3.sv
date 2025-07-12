// TopModule: 1-bit 2-to-1 Multiplexer
// Selects 'a' when sel=0, 'b' when sel=1.
// Continuous assignment with explicit mux intent for synthesis clarity.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

// 2-to-1 multiplexer implemented with continuous assignment
assign out = sel ? b : a;

endmodule