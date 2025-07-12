// TopModule: 1-bit 2-to-1 Multiplexer
// Selects 'a' when sel=0, 'b' when sel=1

module TopModule (
    input  wire a,    // Input data bit a
    input  wire b,    // Input data bit b
    input  wire sel,  // Select signal
    output wire out   // Output of mux
);

// Continuous assignment implementing 2-to-1 mux
assign out = sel ? b : a;

endmodule