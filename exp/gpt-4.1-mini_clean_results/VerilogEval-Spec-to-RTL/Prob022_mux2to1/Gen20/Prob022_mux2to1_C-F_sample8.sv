// TopModule: 1-bit 2-to-1 Multiplexer using continuous assignment
// Outputs 'a' when sel=0, 'b' when sel=1.
// This implementation uses combinational logic with minimal area, power, and delay.

module TopModule (
    input  wire a,    // Input a
    input  wire b,    // Input b
    input  wire sel,  // Select input
    output wire out   // Output of mux
);

    // Continuous assignment implementing the mux functionality.
    assign out = sel ? b : a;

endmodule