module TopModule(in1, in2, in3, out);
    input in1, in2, in3;
    output out;
    wire xnor_out;

    // Implementing XNOR using basic logic
    assign xnor_out = ~(in1 ^ in2);

    // Implementing XOR using the ^ operator
    assign out = xnor_out ^ in3;
endmodule