// TopModule: 1-bit 2-to-1 multiplexer
// Selects 'a' when sel=0, 'b' when sel=1.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = sel ? b : a;

endmodule