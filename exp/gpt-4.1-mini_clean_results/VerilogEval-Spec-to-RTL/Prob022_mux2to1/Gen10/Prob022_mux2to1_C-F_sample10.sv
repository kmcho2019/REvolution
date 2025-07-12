module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

// One-bit 2-to-1 multiplexer:
// When sel=0, out = a; when sel=1, out = b
assign out = sel ? b : a;

endmodule