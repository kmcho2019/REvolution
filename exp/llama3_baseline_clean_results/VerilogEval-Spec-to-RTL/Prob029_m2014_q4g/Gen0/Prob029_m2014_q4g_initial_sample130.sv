module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;

    // XNOR gate: ~(^in1 ^ in2) or ~(in1 ^ in2) 
    // This works because the XNOR operation is equivalent to 
    // the negation of the XOR operation.
    assign out = ~(in1 ^ in2) ^ in3;

endmodule