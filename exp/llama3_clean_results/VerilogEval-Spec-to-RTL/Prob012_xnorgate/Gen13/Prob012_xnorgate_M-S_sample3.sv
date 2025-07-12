// Module TopModule implements an XNOR gate using the equality operator
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using equality operator
assign out = (a == b) ? 1'b1 : 1'b0;  // Output is 1 if inputs are the same, 0 otherwise

endmodule