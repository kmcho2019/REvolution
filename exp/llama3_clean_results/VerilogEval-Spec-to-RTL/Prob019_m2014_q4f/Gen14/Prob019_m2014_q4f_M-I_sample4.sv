module TopModule(
    input in1,
    input in2,
    output out
);

// Directly implement the AND operation with in2 inverted
assign out = in1 & ~in2;

endmodule