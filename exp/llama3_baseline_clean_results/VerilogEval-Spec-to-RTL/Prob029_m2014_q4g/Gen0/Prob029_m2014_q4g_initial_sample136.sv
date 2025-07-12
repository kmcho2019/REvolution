module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    wire xnor_out;

    // Implement XNOR gate
    assign xnor_out = ~(in1 ^ in2);

    // Implement XOR gate
    assign out = xnor_out ^ in3;

endmodule