module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    wire xnor_out;

    // First compute XNOR of in1 and in2
    assign xnor_out = ~(in1 ^ in2);

    // Then compute XOR of xnor_out and in3 for final output
    assign out = xnor_out ^ in3;

endmodule