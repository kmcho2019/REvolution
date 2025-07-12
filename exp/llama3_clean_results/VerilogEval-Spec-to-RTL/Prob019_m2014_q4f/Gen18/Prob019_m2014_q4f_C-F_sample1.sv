module TopModule(
    input in1,
    input in2,
    output out
);
// Directly implement the NAND operation by inverting in2 before the AND operation
// This logic directly corresponds to the circuit description: in1 AND (NOT in2)
assign out = in1 & ~in2;

endmodule