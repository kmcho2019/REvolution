module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xnor_out; // internal signal for XNOR output

    // Implementing XNOR using the equality operator (==) for simplicity
    assign xnor_out = (in1 == in2);

    // Implementing XOR using the ^ operator
    assign out = xnor_out ^ in3;

endmodule