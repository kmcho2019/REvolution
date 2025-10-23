// Module TopModule implements an XNOR gate using basic logic gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires for complemented inputs
wire not_a;  // Complement of input a
wire not_b;  // Complement of input b

// Internal wires for AND gate outputs
wire and_ab;  // Output of AND gate for a and b
wire and_not_ab;  // Output of AND gate for not_a and b

// Assign complemented inputs
assign not_a = ~a;  // Complement of input a
assign not_b = ~b;  // Complement of input b

// Assign AND gate outputs
assign and_ab = a & b;  // Output of AND gate for a and b
assign and_not_ab = not_a & not_b;  // Output of AND gate for not_a and not_b

// Assign final output using OR gate
assign out = and_ab | and_not_ab;  // Output of OR gate for and_ab and and_not_ab

endmodule