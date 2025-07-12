module TopModule(
    input in1,
    input in2,
    output out
);
// Implementing a NAND operation directly
assign out = in1 & ~in2;

endmodule