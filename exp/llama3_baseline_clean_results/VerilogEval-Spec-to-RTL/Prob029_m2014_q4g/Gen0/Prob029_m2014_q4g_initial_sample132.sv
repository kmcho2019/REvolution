module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out; // internal wire for XNOR output

    // Implement XNOR gate
    assign xnor_out = ~(in1 ^ in2);

    // Implement XOR gate with XNOR output and in3 as inputs
    assign out = xnor_out ^ in3;

endmodule