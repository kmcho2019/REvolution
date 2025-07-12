module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Perform the XNOR operation between in1 and in2
// and then the XOR operation with in3 in a single step
assign out = (in1 ~^ in2) ^ in3;

endmodule