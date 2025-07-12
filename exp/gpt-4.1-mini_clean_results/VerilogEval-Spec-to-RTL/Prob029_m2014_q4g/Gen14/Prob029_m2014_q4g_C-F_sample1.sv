module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xnor_out;

    xnor u_xnor (xnor_out, in1, in2);
    xor  u_xor  (out, xnor_out, in3);
endmodule