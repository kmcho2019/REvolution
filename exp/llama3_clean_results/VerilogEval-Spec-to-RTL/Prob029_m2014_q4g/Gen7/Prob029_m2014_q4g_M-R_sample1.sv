module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly combine the XNOR and XOR operations in a single statement for 'out'
assign out = ~(in1 ^ in2) ^ in3;

endmodule