// TopModule: 1-bit 2-to-1 Multiplexer
// Functionality: Outputs input 'a' when 'sel' is 0; outputs input 'b' when 'sel' is 1.
// Implementation: Continuous assignment using a ternary operator for optimal synthesis,
// minimal logic, and clean readability. All inputs and outputs are one-bit wires.

module TopModule (
    input  wire a,    // Data input 0
    input  wire b,    // Data input 1
    input  wire sel,  // Select signal
    output wire out   // Output selected data input
);

// Continuous assignment implements the mux functionality:
// If sel == 0, select 'a', else select 'b'.
assign out = sel ? b : a;

endmodule