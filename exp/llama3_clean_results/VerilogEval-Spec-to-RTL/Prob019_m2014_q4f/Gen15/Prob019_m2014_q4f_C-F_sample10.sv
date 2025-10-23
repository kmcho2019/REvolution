module TopModule(
    input in1,
    input in2,
    output out
);
// This module implements a NAND gate where in2 is inverted before the AND operation.
// The logic is directly implemented as a single line of code for efficiency.
assign out = in1 & ~in2; // Direct implementation of the required logic

endmodule