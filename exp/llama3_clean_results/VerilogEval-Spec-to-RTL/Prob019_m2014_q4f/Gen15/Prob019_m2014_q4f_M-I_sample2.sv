module TopModule(
    input in1,
    input in2,
    output out
);
// Explicitly implementing a NAND operation
// This might allow synthesis tools to optimize more effectively
assign out = ~(in1 & in2);

endmodule