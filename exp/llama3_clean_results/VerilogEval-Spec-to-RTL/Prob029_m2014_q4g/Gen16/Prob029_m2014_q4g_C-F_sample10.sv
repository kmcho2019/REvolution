module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Direct computation using the XNOR and XOR operators for better readability and efficiency
assign out = (in1 ~^ in2) ^ in3;

endmodule