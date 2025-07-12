module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly implement the required logic
assign out = ~(in1 ^ in2) ^ in3;

endmodule