module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Combined XNOR of in1/in2 followed by XOR with in3
    assign out = (in1 ~^ in2) ^ in3;
endmodule