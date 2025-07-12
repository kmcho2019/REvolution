module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Refactor the code to use bitwise operators for XNOR and XOR operations
assign out = (~(^in1 ^ in2)) ^ in3;

endmodule