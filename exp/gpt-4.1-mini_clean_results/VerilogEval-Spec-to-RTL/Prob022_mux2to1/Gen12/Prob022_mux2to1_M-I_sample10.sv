// TopModule: 1-bit 2-to-1 Multiplexer
// Selects between inputs a and b based on sel signal.
// out = a when sel=0, out = b when sel=1.

module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = sel ? b : a;

endmodule