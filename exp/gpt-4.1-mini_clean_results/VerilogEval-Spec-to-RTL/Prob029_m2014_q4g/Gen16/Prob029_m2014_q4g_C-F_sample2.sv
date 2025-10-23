module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xnor_out;

    // Two-input XNOR implemented via continuous assignment
    assign xnor_out = ~(in1 ^ in2);

    // Two-input XOR combining xnor_out and in3
    assign out = xnor_out ^ in3;

endmodule