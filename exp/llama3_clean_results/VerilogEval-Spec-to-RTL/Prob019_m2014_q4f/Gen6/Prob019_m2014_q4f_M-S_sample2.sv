module TopModule(
    input in1,
    input in2,
    output out
);

// Direct implementation of the AND gate with in2 inverted.
assign out = in1 & ~in2;

endmodule