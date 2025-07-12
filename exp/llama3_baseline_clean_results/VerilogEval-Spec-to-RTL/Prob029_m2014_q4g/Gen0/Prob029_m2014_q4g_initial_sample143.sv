module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // First, calculate the XNOR of in1 and in2
    wire xnor_out;
    assign xnor_out = ~(in1 ^ in2);

    // Then, calculate the XOR of the XNOR output and in3
    assign out = xnor_out ^ in3;

endmodule