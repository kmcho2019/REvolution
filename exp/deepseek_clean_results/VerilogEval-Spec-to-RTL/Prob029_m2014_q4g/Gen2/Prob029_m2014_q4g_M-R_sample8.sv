module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Combined XNOR and XOR operations in one expression
    assign out = (~(in1 ^ in2)) ^ in3;

endmodule