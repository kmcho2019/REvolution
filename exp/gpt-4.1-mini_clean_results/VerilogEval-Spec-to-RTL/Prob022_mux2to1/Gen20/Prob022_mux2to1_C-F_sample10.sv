// TopModule: 1-bit 2-to-1 Multiplexer using continuous assignment
// Select between inputs 'a' and 'b' based on 'sel'.
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = sel ? b : a;

endmodule