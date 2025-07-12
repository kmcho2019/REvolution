// Module TopModule implements an XNOR gate
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Use the ~ (NOT) operator with the ^ (XOR) operator to implement the XNOR operation
assign out = ~(a ^ b);

endmodule