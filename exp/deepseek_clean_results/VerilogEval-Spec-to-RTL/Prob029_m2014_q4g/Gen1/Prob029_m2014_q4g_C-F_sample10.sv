module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;
    
    // First stage: XNOR using concise operator
    assign xnor_out = in1 ~^ in2;
    
    // Second stage: XOR with in3
    assign out = xnor_out ^ in3;

endmodule