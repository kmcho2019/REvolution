module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    // Create a wire to hold the output of the XNOR gate
    wire xnor_out;

    // Implement the XNOR gate using the equality operator (==)
    assign xnor_out = (in1 == in2);

    // Implement the XOR gate using the XOR operator (^)
    assign out = xnor_out ^ in3;

endmodule