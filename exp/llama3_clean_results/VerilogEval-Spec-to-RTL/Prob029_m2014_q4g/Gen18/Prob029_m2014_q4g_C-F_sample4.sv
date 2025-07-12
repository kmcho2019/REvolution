module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement the entire logic in a single line of code, relying on the synthesis tool to optimize the design
assign out = ~(in1 ^ in2) ^ in3;

endmodule