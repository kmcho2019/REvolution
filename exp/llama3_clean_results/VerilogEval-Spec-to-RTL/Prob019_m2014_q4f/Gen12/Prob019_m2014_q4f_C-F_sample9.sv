module TopModule(
    input in1,
    input in2,
    output out
);

// Direct implementation of the required logic
assign out = in1 & ~in2;

endmodule