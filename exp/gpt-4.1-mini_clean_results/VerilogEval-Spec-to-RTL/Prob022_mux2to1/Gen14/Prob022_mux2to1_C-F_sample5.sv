// TopModule: 1-bit 2-to-1 Multiplexer
// Selects input 'a' when sel=0, and input 'b' when sel=1.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = sel ? b : a;

endmodule