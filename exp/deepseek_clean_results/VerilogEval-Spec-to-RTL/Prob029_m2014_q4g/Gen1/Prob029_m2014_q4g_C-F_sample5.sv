module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xnor_out;
    
    assign xnor_out = in1 ~^ in2;  // Efficient XNOR operation
    assign out = xnor_out ^ in3;   // Direct XOR implementation
endmodule