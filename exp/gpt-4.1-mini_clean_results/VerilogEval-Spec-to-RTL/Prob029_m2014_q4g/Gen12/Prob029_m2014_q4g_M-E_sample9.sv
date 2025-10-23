module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;

    xnor U1 (xnor_out, in1, in2);
    xor  U2 (out, xnor_out, in3);

endmodule