module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

assign out = (in1 == in2) ^ in3;

// Alternatively, using the ~= operator for XNOR and ^ for XOR, the same logic can be expressed as:
// assign out = ~(in1 ^ in2) ^ in3;

endmodule