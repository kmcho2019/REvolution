// TopModule: 1-bit 2-to-1 Multiplexer
// When sel=0, out = a; when sel=1, out = b.
// Implemented using continuous assignment.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = sel ? b : a;

endmodule