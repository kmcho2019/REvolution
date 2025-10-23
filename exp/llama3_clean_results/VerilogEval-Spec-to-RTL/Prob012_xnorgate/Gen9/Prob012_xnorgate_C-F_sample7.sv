// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Parameter to select the implementation
parameter IMPLEMENTATION = 0; // 0: Equality operator, 1: Basic logical operators

// Use the equality operator to implement the XNOR gate
wire out_eq;
assign out_eq = (a == b);

// Use basic logical operators to implement the XNOR gate
wire out_logic;
assign out_logic = (a & b) | (~a & ~b);

// Select the implementation based on the parameter
assign out = (IMPLEMENTATION == 0) ? out_eq : out_logic;

endmodule