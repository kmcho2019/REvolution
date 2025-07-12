// Simplified Module TopModule implements an XNOR gate using the equality operator
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly assign the output based on the equality of inputs
assign out = ~(a ^ b);

endmodule