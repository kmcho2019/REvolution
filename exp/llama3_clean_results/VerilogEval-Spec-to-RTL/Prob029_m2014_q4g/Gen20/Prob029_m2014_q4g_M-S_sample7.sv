module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly assign the result of the operation to the output
assign out = !(in1 ^ in2) ^ in3;

endmodule