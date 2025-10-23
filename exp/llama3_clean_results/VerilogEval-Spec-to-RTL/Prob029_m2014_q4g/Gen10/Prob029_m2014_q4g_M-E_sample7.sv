module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implementing the XNOR operation explicitly
wire xnor_result = ~(in1 ^ in2);

// Then using this result in the XOR operation with 'in3'
assign out = xnor_result ^ in3;

// Alternatively, expressing the logic using a conditional statement
// assign out = (in1 == in2) ? ~in3 : in3;

endmodule