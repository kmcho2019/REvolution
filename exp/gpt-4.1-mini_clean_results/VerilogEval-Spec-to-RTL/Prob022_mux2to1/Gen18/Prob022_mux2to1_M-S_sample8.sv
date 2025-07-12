// TopModule: 1-bit 2-to-1 Multiplexer using simple Boolean expression
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = (~sel & a) | (sel & b);

endmodule