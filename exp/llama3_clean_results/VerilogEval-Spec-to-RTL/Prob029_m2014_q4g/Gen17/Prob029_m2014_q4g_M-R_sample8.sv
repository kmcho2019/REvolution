module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_result; // Declare a wire for the XNOR operation result
assign xnor_result = ~(in1 ^ in2); // Perform the XNOR operation
assign out = xnor_result ^ in3; // Use the XNOR result in the XOR operation

endmodule