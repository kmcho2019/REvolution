module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    assign out = ~(in1 ^ in2) ^ in3;

    // Alternatively, the XNOR can be explicitly implemented as follows:
    // assign xnor_out = ~(in1 ^ in2);
    // assign out = xnor_out ^ in3;
endmodule