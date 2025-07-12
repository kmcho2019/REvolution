module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement XNOR using basic logic gates
wire xnor_result;
assign xnor_result = (in1 && in2) || (!in1 && !in2);

// Implement XOR using basic logic gates
assign out = (xnor_result && !in3) || (!xnor_result && in3);

endmodule