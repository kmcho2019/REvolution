module TopModule(
    input in1,
    input in2,
    output out
);
// The logical expression remains the same due to the simplicity and efficiency of the current implementation
assign out = in1 & ~in2;

endmodule