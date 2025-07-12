module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    wire xor_out;      // intermediate xor of in1 and in2
    wire xnor_out;     // output of xnor = not(xor_out)

    // XNOR implementation: xor followed by not
    xor u_xor1 (xor_out, in1, in2);
    not u_not1 (xnor_out, xor_out);

    // Final XOR with in3
    xor u_xor2 (out, xnor_out, in3);

endmodule