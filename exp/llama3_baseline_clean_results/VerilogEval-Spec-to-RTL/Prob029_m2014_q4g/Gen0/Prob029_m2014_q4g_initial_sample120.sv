module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;
    wire xnor_out;

    // Two-input XNOR gate
    assign xnor_out = ~(in1 ^ in2);

    // Two-input XOR gate
    assign out = xnor_out ^ in3;

endmodule