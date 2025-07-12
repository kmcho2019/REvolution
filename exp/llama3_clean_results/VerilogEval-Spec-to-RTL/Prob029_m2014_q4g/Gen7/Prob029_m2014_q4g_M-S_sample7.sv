module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    assign out = ~(in1 ^ in2 ^ in3); // Directly utilize XOR properties for XNOR and XOR operations

endmodule