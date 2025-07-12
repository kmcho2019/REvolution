module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement XNOR using basic logic gates (AND, OR, NOT)
wire xnor_result;
assign xnor_result = ~(in1 ^ in2);

// Apply XOR operation to XNOR result and in3
assign out = xnor_result ^ in3;

endmodule