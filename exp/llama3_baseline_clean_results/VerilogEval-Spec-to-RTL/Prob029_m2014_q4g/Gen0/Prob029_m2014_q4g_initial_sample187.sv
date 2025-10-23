module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;
    
    // Intermediate signal to hold the output of the XNOR gate
    wire xnor_out;
    
    // Implement two-input XNOR gate
    assign xnor_out = ~(in1 ^ in2);
    
    // Implement two-input XOR gate
    assign out = xnor_out ^ in3;
    
endmodule