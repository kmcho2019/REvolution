module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;
    assign xnor_out = ~(in1 ^ in2); // XNOR using XOR and NOT
    assign out = xnor_out ^ in3; // XOR

endmodule