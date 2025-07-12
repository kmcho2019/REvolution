module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly compute the output
assign out = (in1 ~^ in2) ^ in3;

endmodule