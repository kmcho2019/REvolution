// Module TopModule implements an XNOR gate using logical operators
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly assign the XNOR operation result to the output
assign out = ~(a ^ b);

endmodule