module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Implements: (in1 XNOR in2) XOR in3
    assign out = (in1 ~^ in2) ^ in3;

endmodule