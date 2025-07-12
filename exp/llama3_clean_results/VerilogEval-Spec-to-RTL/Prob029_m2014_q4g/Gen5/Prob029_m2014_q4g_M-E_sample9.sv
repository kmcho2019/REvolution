module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signal to hold the result of the XOR operation between in1 and in2
wire xor_result;

// Compute the XOR of in1 and in2
assign xor_result = in1 ^ in2;

// Use the negation of the XOR result ( effectively XNOR ) and compute the XOR with in3
assign out = ~(xor_result) ^ in3;

endmodule