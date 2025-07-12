module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Intermediate signal for XNOR result
    wire xnor_result;
    
    // First stage: XNOR of in1 and in2
    assign xnor_result = in1 ~^ in2;
    
    // Second stage: XOR with in3
    assign out = xnor_result ^ in3;
endmodule