module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    wire xnor_out;

    // Instantiate XNOR gate primitive
    xnor (xnor_out, in1, in2);

    // Instantiate XOR gate primitive
    xor (out, xnor_out, in3);

endmodule