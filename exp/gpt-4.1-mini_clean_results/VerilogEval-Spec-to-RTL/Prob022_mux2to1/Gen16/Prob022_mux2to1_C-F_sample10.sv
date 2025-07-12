// TopModule: 1-bit 2-to-1 Multiplexer
// Selects between input 'a' and 'b' based on select signal 'sel'.
// When sel=0, output 'out' equals 'a'; when sel=1, output 'out' equals 'b'.
// Implemented as a continuous assignment with a ternary operator for optimal synthesis,
// minimal logic, and zero timing slack.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

    // Output driven by a 2-to-1 mux selecting between 'a' and 'b' based on 'sel'
    assign out = sel ? b : a;

endmodule