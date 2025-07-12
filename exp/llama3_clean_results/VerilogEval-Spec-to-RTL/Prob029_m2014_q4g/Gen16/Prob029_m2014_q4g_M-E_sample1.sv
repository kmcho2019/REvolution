module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Novel architectural solution expressing the output as a function of inputs
assign out = ~(in1 ^ in2 ^ in3);

endmodule