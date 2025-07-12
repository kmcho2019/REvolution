module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    assign out = (in1 ~^ in2) ^ in3;  // Direct implementation using XNOR and XOR operators

endmodule