module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly compute the output without an intermediate signal
assign out = (in1 == in2) ^ in3;

endmodule