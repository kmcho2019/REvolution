// Module TopModule implements an XNOR gate using a logical expression
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Direct XNOR implementation using bitwise XOR and inversion
assign out = ~(a ^ b);  // Invert the result of XOR to get XNOR

endmodule