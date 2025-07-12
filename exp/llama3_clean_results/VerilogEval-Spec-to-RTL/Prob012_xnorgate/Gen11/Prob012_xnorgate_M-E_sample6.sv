// Module TopModule implements an XNOR gate using AND, OR, and NOT gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires for AND operations
wire and_ab;  // Output of a AND b
wire and_nab; // Output of NOT a AND NOT b

// Assign AND operations
assign and_ab = a & b;
assign and_nab = ~a & ~b;

// Assign OR operation to combine AND results
assign out = and_ab | and_nab;

endmodule