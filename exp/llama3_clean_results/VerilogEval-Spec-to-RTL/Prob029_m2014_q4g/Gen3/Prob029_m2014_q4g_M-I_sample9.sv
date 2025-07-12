module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    // Direct implementation of the required logic
    assign out = ~(in1 ^ in2) ^ in3;

    // Alternatively, to potentially aid synthesis optimization, 
    // we could break it down, though for such simple logic, 
    // this might not yield significant improvements:
    // wire xnor_out;
    // assign xnor_out = ~(in1 ^ in2);
    // assign out = xnor_out ^ in3;

endmodule