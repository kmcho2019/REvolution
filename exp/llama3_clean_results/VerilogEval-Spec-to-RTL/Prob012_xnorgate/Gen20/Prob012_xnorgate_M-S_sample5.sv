// Module TopModule implements an XNOR gate using equality comparison
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using equality comparison
assign out = (a == b);

endmodule