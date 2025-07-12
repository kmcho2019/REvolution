module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out; // Output of the XNOR gate

    // Implementing the XNOR gate
    assign xnor_out = ~(in1 ^ in2);

    // Implementing the XOR gate with the output of XNOR and in3
    assign out = xnor_out ^ in3;

endmodule