module TopModule(
    input in1,
    input in2,
    output out
);
// Implementing a NAND operation directly for the given inputs
// The bubble on in2 implies inversion, thus in1 & ~in2 directly implements the required logic
assign out = in1 & (~in2); // Direct computation of the output

endmodule