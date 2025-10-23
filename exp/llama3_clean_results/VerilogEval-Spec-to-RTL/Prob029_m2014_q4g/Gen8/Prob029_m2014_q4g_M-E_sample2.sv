module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    assign out = ~(in1 ^ in2) ^ in3; // Direct implementation using XOR and NOT operators

endmodule