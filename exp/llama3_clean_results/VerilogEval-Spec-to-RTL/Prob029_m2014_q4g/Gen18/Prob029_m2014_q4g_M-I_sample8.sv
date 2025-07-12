module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The operation can be seen as an XNOR followed by an XOR, but let's express it directly for clarity and potential synthesis optimization
assign out = ~(in1 ^ in2) ^ in3;

endmodule