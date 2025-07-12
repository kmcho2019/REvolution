module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    wire xn_out;

    // Compute XNOR of in1 and in2 directly using assign statement
    assign xn_out = ~(in1 ^ in2);

    // Compute XOR of xn_out and in3 directly and assign to output
    assign out = xn_out ^ in3;

endmodule