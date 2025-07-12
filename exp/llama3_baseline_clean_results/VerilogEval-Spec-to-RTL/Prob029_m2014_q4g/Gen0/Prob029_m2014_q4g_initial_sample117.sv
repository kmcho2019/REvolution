module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Implementing the XNOR gate using the equality operator
    // and then using its output in the XOR gate
    assign out = (in1 == in2) ^ in3;

endmodule