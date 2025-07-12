module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Implement out = XOR of in3 and XNOR of in1 and in2
    assign out = (in1 ~^ in2) ^ in3;
endmodule