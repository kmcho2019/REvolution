module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Intermediate signal for XNOR result
    wire in1_in2_xnor = in1 ~^ in2;
    
    // Final XOR with in3
    assign out = in1_in2_xnor ^ in3;

endmodule