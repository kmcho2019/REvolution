module TopModule(
    input in1,
    input in2,
    output out
);

assign out = in1 & ~in2; // Directly assign the result of AND operation with in2 inverted

endmodule