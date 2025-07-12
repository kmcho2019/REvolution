module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out; // Intermediate wire to hold the output of the XNOR operation
    assign xnor_out = ~(in1 ^ in2); // Implementing XNOR using XOR and NOT
    assign out = xnor_out ^ in3; // Implementing the final XOR operation

endmodule