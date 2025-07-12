module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Simplified implementation using bitwise operators
assign out = in3 ^ (in1 ^ in2);

endmodule