module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // First stage: XNOR of in1 and in2
    wire xnor_out = ~(in1 ^ in2);
    
    // Second stage: XOR with in3
    assign out = xnor_out ^ in3;
endmodule