module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Compute XNOR of in1 and in2 using Verilog's built-in operator
    wire xnor_out = ~(in1 ^ in2);

    // XOR the XNOR result with in3 for final output
    assign out = xnor_out ^ in3;

endmodule