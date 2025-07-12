module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Simplified expression directly computing the output
// Using the property that ~(a ^ b) ^ c = (a == b) ^ c
assign out = ~(in1 ^ in2) ^ in3;

// Alternatively, recognizing the equivalence to (in1 == in2) ^ in3
// and applying De Morgan's laws and other Boolean simplifications,
// the expression can be optimized further if needed, but in this case,
// the existing expression is already optimized for simplicity and logic complexity.

endmodule