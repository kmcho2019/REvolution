// Module TopModule implements an XNOR gate using the equality operator
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly implement XNOR using the equality operator
assign out = (a == b); // XNOR is equivalent to checking if a and b are equal

endmodule