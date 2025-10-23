module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // First MUX implements XNOR of in1 and in2
    wire xnor_result = (in1 == in2) ? 1'b1 : 1'b0;
    
    // Second MUX implements XOR with in3
    assign out = in3 ? ~xnor_result : xnor_result;
endmodule