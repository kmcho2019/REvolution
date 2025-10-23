module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    assign out = ~(in1 ^ in2) ^ in3;

    // Alternatively, for clarity and educational purposes, we can explicitly define the XNOR operation
    // and then use its output in the XOR operation.
    // wire xnor_out;
    // assign xnor_out = ~(in1 ^ in2);
    // assign out = xnor_out ^ in3;
endmodule