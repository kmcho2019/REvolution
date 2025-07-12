// Module TopModule implements an XNOR gate using both equality operator and AND/OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out_equal, // Output signal using equality operator
    output out_gates  // Output signal using AND and OR gates
);

// Directly implement XNOR using the equality operator
assign out_equal = ~(a ^ b); // XNOR is equivalent to NOT(XOR)

// Internal wires for AND gate outputs
wire and_a_b;  // Output of AND gate for inputs a and b
wire and_a_b_bar;  // Output of AND gate for inputs a and b_bar (inverted b)

// Assign output of AND gates
assign and_a_b = a & b;  // Both inputs are 1
assign and_a_b_bar = (~a) & (~b);  // Both inputs are 0 (inverted)

// Assign output of OR gate to generate XNOR result
assign out_gates = and_a_b | and_a_b_bar;  // Output is 1 if both inputs are the same

endmodule