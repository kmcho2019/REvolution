module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Combine XNOR and XOR into a single expression for optimized PPA
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule