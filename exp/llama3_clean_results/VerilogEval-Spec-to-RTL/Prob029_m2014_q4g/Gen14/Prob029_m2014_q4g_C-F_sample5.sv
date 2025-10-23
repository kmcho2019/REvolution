module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Intermediate signal to hold the result of the XNOR operation
wire xnor_result;

// Perform the XNOR operation between in1 and in2
assign xnor_result = (in1 == in2);

// Perform the XOR operation between the XNOR result and in3
assign out = xnor_result ^ in3;

endmodule