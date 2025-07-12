module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The existing expression is already simplified for direct computation.
// However, to further ensure optimization for PPA metrics, we maintain the simplicity
// and directness of the logic, leveraging the properties of XOR and XNOR operations.
assign out = (in1 == in2) ^ in3;

// Alternatively, the expression could be kept as in the original solution,
// given that both expressions are functionally equivalent and the synthesis tool
// can optimize them based on the target technology library and constraints.
// assign out = ~(in1 ^ in2) ^ in3;

endmodule