// Module TopModule implements an XNOR gate
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly implement the XNOR operation using the equality operator
assign out = (a == b) ? 1'b1 : 1'b0;

endmodule