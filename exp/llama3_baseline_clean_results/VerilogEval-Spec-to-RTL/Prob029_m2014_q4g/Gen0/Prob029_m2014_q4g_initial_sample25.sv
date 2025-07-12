module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;

    // Implementing XNOR using equality operator for simplicity
    assign xnor_out = (in1 == in2);
    
    // Implementing XOR
    assign out = xnor_out ^ in3;

endmodule