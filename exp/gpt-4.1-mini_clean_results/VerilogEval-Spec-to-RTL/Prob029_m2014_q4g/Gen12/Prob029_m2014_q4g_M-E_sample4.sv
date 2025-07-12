module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Directly assign out = ((in1 XNOR in2) XOR in3)
    // XNOR can be expressed as ~(in1 ^ in2)
    assign out = (~(in1 ^ in2)) ^ in3;

endmodule