module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

    // Intermediate signal for the output of the XNOR gate
    wire xnor_out;

    // XNOR gate implementation using the ~^ operator
    assign xnor_out = ~(in1 ^ in2);

    // XOR gate implementation using the ^ operator
    assign out = xnor_out ^ in3;

endmodule