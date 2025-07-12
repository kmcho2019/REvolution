module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;

    // First, compute XNOR of in1 and in2
    assign xnor_out = ~(in1 ^ in2);

    // Then XOR the result with in3
    assign out = xnor_out ^ in3;

endmodule