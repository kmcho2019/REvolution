module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Intermediate wire holding the XNOR of in1 and in2
    wire xnor_out;

    // Two-input XNOR operation
    assign xnor_out = ~(in1 ^ in2);

    // XOR of the XNOR result and in3 producing the output
    assign out = xnor_out ^ in3;

endmodule