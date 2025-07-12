module TopModule(
    input  in1,
    input  in2,
    output out
);

// Directly assign the result of the AND operation with in2 inverted to out
assign out = in1 & ~in2;

endmodule