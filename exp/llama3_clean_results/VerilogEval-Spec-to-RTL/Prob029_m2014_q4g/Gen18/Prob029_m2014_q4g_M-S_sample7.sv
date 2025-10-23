module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Simplify the expression by directly using the fact that ~(in1 ^ in2) is equivalent to in1 === in2 (XNOR)
// and then applying XOR with in3, which can be directly implemented using basic operations.
assign out = (in1 == in2) ^ in3;

endmodule