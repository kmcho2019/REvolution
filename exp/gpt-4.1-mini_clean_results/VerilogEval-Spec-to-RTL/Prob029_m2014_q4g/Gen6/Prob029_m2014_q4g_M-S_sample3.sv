module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

xnor (xnor_out, in1, in2);
xor  (out, xnor_out, in3);

endmodule