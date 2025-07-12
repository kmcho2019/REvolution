module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    wire xnor_out;

    // Instantiate an XNOR gate for in1 and in2
    xnor U1 (xnor_out, in1, in2);

    // Instantiate an XOR gate with xnor_out and in3
    xor U2 (out, xnor_out, in3);

endmodule