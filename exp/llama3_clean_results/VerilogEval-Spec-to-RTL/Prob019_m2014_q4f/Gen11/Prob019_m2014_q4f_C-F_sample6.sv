module TopModule(
    input in1,
    input in2,
    output out
);

// Directly assign the output with explicit inversion of in2 for clarity and efficiency
assign out = in1 & (~in2);

endmodule