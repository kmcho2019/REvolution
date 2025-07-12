module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_result;

    // Direct continuous assignment for XNOR of in1 and in2
    assign xnor_result = ~(in1 ^ in2);

    // XOR xnor_result with in3 to generate out
    assign out = xnor_result ^ in3;

endmodule