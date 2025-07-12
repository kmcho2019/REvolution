// Module TopModule implements an XNOR gate using basic logical operations
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using logical operators
assign out = ~(a ^ b);  // Output is 1 if inputs are the same, 0 otherwise

endmodule