module TopModule(in1, in2, in3, out);
    input in1;
    input in2;
    input in3;
    output out;

    wire xnor_out;
    assign xnor_out = ~(in1 ^ in2); // Define XNOR operation explicitly
    assign out = xnor_out ^ in3; // Use XNOR output as input to XOR operation

endmodule