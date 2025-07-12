module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;
    
    assign out = ~(in1 ^ in2) ^ in3;
    // Alternatively, the following line can be used for clarity on the XNOR operation
    // assign out = (in1 == in2) ^ in3;
endmodule