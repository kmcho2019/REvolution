module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;
    wire xnor_out;

    assign xnor_out = ~(in1 ^ in2); // XNOR operation
    assign out = xnor_out ^ in3; // XOR operation

endmodule