// Module TopModule implements an XNOR gate
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using equality check
assign out = (a == b);  // XNOR operation: output is 1 if inputs are the same

endmodule