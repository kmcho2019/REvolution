module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xnor_result = in1 ~^ in2;  // First stage: XNOR of in1 and in2
    assign out = xnor_result ^ in3;  // Second stage: XOR with in3
endmodule