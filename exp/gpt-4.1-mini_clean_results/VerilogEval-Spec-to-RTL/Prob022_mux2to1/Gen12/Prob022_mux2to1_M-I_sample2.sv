// TopModule: 1-bit 2-to-1 Multiplexer using continuous assignment
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = sel ? b : a;

endmodule