module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Implementing XNOR using equality operator
    // wire xnor_out = (in1 == in2);

    // Implementing XNOR using bitwise XOR operator and inverting the result
    wire xnor_out = ~(in1 ^ in2);

    // Implementing XOR with 'in3'
    assign out = xnor_out ^ in3;

endmodule