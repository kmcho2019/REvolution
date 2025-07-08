module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xnor_out;
    
    assign xnor_out = in1 ~^ in2;  // XNOR operation between in1 and in2
    assign out = xnor_out ^ in3;   // XOR operation between xnor_out and in3
endmodule