module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Direct and simplified computation by combining the XNOR and XOR operations
assign out = (in1 == in2) ^ in3;

endmodule